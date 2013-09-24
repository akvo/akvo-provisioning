# This class pulls together the parts which are required by both installed
# and development versions of RSR

class rsr::common {

    # some shared config
    $username = 'rsr'
    $approot = '/var/akvo/rsr'
    $database_password = hiera('rsr_database_password')
    $base_domain = hiera('base_domain')
    $database_host = "mysql.${base_domain}"
    $media_root = "${approot}/mediaroot/"
    $logdir = "${approot}/logs/"
    $port = 8000
    $site_id = hiera('rsr_site_id')

    $rsr_secret_key = hiera('rsr_secret_key')
    $additional_rsr_domains = hiera_array('rsr_additional_rsr_domains', [])
    $partner_site_domain = hiera('rsr_partner_site_domain')

    $rsr_hostnames = concat($additional_rsr_domains, ["rsr.${base_domain}"])


    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    require akvoapp


    # install all of the support packages
    include pythonsupport::mysql
    include pythonsupport::pil
    include pythonsupport::lxml
    include pythonsupport::standard


    # include our RSR-specific akvo info
    rsr::user { 'rsr':
        approot  => $approot,
        username => $username,
    }
    rsr::dirs { 'rsr':
        username   => $username,
        approot    => $approot,
        media_root => $media_root,
    }

    # include the script for downloading and creating an app
    file { "${approot}/make_app.sh":
        ensure  => present,
        content => template('rsr/make_app.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for switching the app
    file { "${approot}/make_current.sh":
        ensure  => present,
        content => template('rsr/make_current.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for switching the app
    file { "${approot}/update_current.sh":
        ensure  => present,
        content => template('rsr/update_current.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for cleaning up old versions
    file { "${approot}/cleanup_old.sh":
        ensure  => present,
        content => template('rsr/cleanup_old.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for managing the django application
    file { "${approot}/manage.sh":
        ensure  => present,
        content => template('rsr/manage.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # add custom configuration
    $use_graphite = hiera("rsr_use_graphite", false)
    if $use_graphite {
        $statsd_host = hiera('statsd_host', "statsd.${base_domain}")
        $statsd_port = 8125
        $statsd_prefix = "rsr.${::environment}"
    }

    file { "${approot}/local_settings.conf":
        ensure   => present,
        owner    => 'rsr',
        group    => 'rsr',
        mode     => '0444',
        content  => template('rsr/local.conf.erb'),
    }


    # create an RSR database on the database server
    database::my_sql::db { 'rsr':
        password => $database_password
    }


    # we want a service address
    named::service_location { ["rsr", "*"]:
        ip => hiera('external_ip')
    }


    # nginx sits in front of RSR
    nginx::proxy { [$rsr_hostnames, "*.${base_domain}", "*.${partner_site_domain}"]:
        proxy_url          => "http://localhost:${port}",
        static_dirs        => {
            "/media/admin/" => "${approot}/venv/lib/python2.7/site-packages/django/contrib/admin/static/admin/",
            "/media/"       => $media_root,
        },
    }


    # let the build server know how to log in to us
    @@teamcity::deploykey { "rsr-${::environment}":
        service     => 'rsr',
        environment => $::environment,
        key         => hiera('rsr-deploy_private_key'),
    }


    # configure a service so we can start and restart RSR
    supervisord::service { "rsr":
        user      => 'rsr',
        command   => "${approot}/venv/bin/gunicorn akvo.wsgi --pid ${approot}/rsr.pid --bind 127.0.0.1:${port}",
        directory => $approot,
        env_vars  => {
            'PYTHONPATH' => "${approot}/code/"
        }
    }
    # we want the rsr user to be able to restart the process
    sudo::service_control { "rsr":
        user         => 'rsr',
    }

}