class rsr::config inherits rsr::params {

    # create an RSR database on the database server
    database::psql::db { $database_name:
        psql_name      => $postgres_name,
        password       => $database_password,
        reportable     => true,
        allow_createdb => $allow_createdb
    }

    # we want a service address
    named::service_location { ["rsr", "*"]:
        ip => hiera('external_ip')
    }

    # nginx sits in front of RSR
    $base_domain = hiera('base_domain')
    nginx::proxy { [$rsr_hostnames, "*.${base_domain}"]:
        proxy_url                 => "http://localhost:${port}",
        extra_nginx_proxy_config  => template('rsr/nginx-extra-proxy.conf.erb'),
        ssl                       => true,
        ssl_key_source            => hiera('akvo_wildcard_key'),
        ssl_cert_source           => hiera('akvo_wildcard_cert'),
        static_dirs               => {
            "/media/"  => $media_root,
            "/static/" => $static_root
        },
        extra_nginx_server_config => template('rsr/nginx-extra-server.conf.erb'),
        access_log                => "${approot}/logs/rsr-nginx-access.log",
        error_log                 => "${approot}/logs/rsr-nginx-error.log",
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

    file { "${approot}/local_settings.conf":
        ensure   => present,
        owner    => $username,
        group    => $username,
        mode     => '0444',
        content  => template('rsr/local.conf.erb'),
        notify   => Class['supervisord::update']
    }

    sudo::allow_as_user { 'devs_can_rsr':
        group => 'developer',
        as_user => 'rsr'
    }

    file { "${approot}/backup_key":
        ensure  => present,
        owner   => 'rsr',
        group   => 'rsr',
        mode    => '0600',
        content => hiera('backup_private_key')
    }
}
