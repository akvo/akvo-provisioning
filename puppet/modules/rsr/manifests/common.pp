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


    # we need the list of partners:
    $partners = hiera('rsr_partners')
    # and we want to combine that with the standard RSR app

    $rsr_secret_key = hiera('rsr_secret_key')
    $additional_rsr_domains = hiera('rsr_additional_rsr_domains')
    $partner_site_domain = hiera('rsr_partner_site_domain')

    $rsr_hostnames = concat($additional_rsr_domains, ["rsr.${base_domain}"])
    $partner_hostnames = concat(suffix($partners, ".${base_domain}"), suffix($partners, ".${partner_site_domain}"))
    $all_hostnames = concat(concat([], $rsr_hostnames), $partner_hostnames)
    # note: we concatenate onto an empty array because otherwise $rsr_hostnames would have $partner_hostnames appended
    # to it as well...
    $all_sites = concat(['rsr'], $partners)


    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    require akvoapp
    require rsr::packages

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
        mode    => 744,
        require => File[$approot]
    }

    # include the script for switching the app
    file { "${approot}/make_current.sh":
        ensure  => present,
        content => template('rsr/make_current.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => 744,
        require => File[$approot]
    }

    # include the script for switching the app
    file { "${approot}/update_current.sh":
        ensure  => present,
        content => template('rsr/update_current.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => 744,
        require => File[$approot]
    }

    # add custom configuration
    file { "${approot}/local_settings.conf":
        ensure   => present,
        owner    => 'rsr',
        group    => 'rsr',
        mode     => 444,
        content  => template('rsr/local.conf.erb'),
    }


    # install all of the support packages
    include pythonsupport::mysql
    include pythonsupport::pil
    include pythonsupport::lxml


    # create an RSR database on the database server
    database::my_sql::db { 'rsr':
        password => $database_password
    }


    # we want a service address
    named::service_location { $all_sites:
        ip => hiera('external_ip')
    }


    # nginx sits in front of RSR
    nginx::proxy { $all_hostnames:
        proxy_url          => "http://localhost:${port}",
        static_dirs        => {
            "/media/admin/" => "${approot}/venv/lib/python2.7/site-packages/django/contrib/admin/static/admin/",
            "/media/"       => $media_root,
        }
    }


    # configure a service so we can start and restart RSR
    include supervisord
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