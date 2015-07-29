class unilog::config inherits unilog::params {

    database::psql::db { $appname:
        psql_name  => $postgres_name,
        password   => $database_password
    }

    # we want a service address
    named::service_location { $appname:
        ip => hiera('external_ip')
    }

    # nginx sits in front of unilog
    $base_domain = hiera('base_domain')
    nginx::proxy { $main_domain:
        proxy_url       => "http://localhost:${appport}",
        htpasswd        => false,
        ssl             => true,
        ssl_key_source  => hiera('akvo_wildcard_key'),
        ssl_cert_source => hiera('akvo_wildcard_cert_complete'),
        access_log      => "${logdir}/unilog-nginx-access.log",
        error_log       => "${logdir}/unilog-nginx-error.log",
    }

    # let the build server know how to log in to us
    @@teamcity::deploykey { "unilog-${::environment}":
        service     => 'unilog',
        environment => $::environment,
        key         => hiera('unilog-deploy_private_key'),
    }

    # no password - we need that setting for the deployment scripts
    sudo::admin_user { $username:
        nopassword => true
    }
}
