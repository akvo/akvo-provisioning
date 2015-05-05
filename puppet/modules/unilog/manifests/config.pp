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
    nginx::proxy { "unilog.${base_domain}":
        proxy_url  => "http://localhost:${port}",
        access_log => "${logdir}/unilog-nginx-access.log",
        error_log  => "${logdir}/unilog-nginx-error.log",
    }

}
