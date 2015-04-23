class rsr::config {

    include rsr::params
    $approot = $rsr::params::approot

    # create an RSR database on the database server
    database::psql::db { 'rsr':
        psql_name  => $rsr::params::postgres_name,
        password   => $rsr::params::database_password,
        reportable => true
    }

    # we want a service address
    named::service_location { ["rsr", "*"]:
        ip => hiera('external_ip')
    }

    # nginx sits in front of RSR
    $base_domain = hiera('base_domain')
    nginx::proxy { [$rsr::params::rsr_hostnames, "*.${base_domain}", "*.${rsr::params::partner_site_domain}", "_"]:
        proxy_url          => "http://localhost:${rsr::params::port}",
        static_dirs        => {
            # "/media/admin/" => "${approot}/venv/lib/python2.7/site-packages/django/contrib/admin/static/admin/",
            "/media/"       => $rsr::params::media_root,
            "/static/"      => $rsr::params::static_root
        },
        extra_nginx_config  => template('rsr/nginx-extra.conf.erb'),
        access_log          => "${approot}/logs/rsr-nginx-access.log",
        error_log           => "${approot}/logs/rsr-nginx-error.log",
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
        $statsd_host = '127.0.0.1'
        $statsd_port = 8125
        $statsd_prefix = "rsr.${::environment}"
    }

    $use_sentry = hiera('rsr_use_sentry', false)
    if $use_sentry {
        $sentry_dsn = hiera('rsr_sentry_dsn')
    }

    $smtp_user = $rsr::params::smtp_user
    $smtp_password = $rsr::params::smtp_password

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
