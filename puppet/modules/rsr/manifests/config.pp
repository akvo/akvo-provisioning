
class rsr::config {

    include rsr::params

    # create an RSR database on the database server
    database::my_sql::db { 'rsr':
        password => $rsr::params::database_password
    }

    # we want a service address
    named::service_location { ["rsr", "*"]:
        ip => hiera('external_ip')
    }

    # nginx sits in front of RSR
    $base_domain = hiera('base_domain')
    nginx::proxy { [$rsr::params::rsr_hostnames, "*.${base_domain}", "*.${rsr::params::partner_site_domain}"]:
        proxy_url          => "http://localhost:${rsr::params::port}",
        static_dirs        => {
            "/media/admin/" => "${rsr::params::approot}/venv/lib/python2.7/site-packages/django/contrib/admin/static/admin/",
            "/media/"       => $rsr::params::media_root
        },
        extra_nginx_config  => "client_max_body_size 3m;",
    }


    # let the build server know how to log in to us
    @@teamcity::deploykey { "rsr-${::environment}":
        service     => 'rsr',
        environment => $::environment,
        key         => hiera('rsr-deploy_private_key'),
    }


    # RSR env-specific config
    $use_graphite = hiera('rsr_use_graphite')
    if $use_graphite {
        $statsd_host = hiera('statsd_host', "statsd.${base_domain}")
        $statsd_port = 8125
        $statsd_prefix = "rsr.${::environment}"
    }

    $main_domain = $rsr::params::main_domain
    $partner_site_domain = $rsr::params::partner_site_domain
    file { "${rsr::params::approot}/local_settings.conf":
        ensure   => present,
        owner    => $rsr::params::username,
        group    => $rsr::params::username,
        mode     => '0444',
        content  => template('rsr/local.conf.erb'),
        notify   => Class['supervisord::update']
    }

}