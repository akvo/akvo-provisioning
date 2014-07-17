
class tessera::config {

    include tessera::params
    $approot = $tessera::params::approot

    # create an butler database on the database server
    database::my_sql::db { $tessera::params::dbname:
        password   => $tessera::params::database_password,
        reportable => false
    }

    # we want a service address
    named::service_location { 'tessera':
        ip => hiera('external_ip')
    }

    # nginx sits in front of butler
    $base_domain = hiera('base_domain')
        nginx::proxy { "tessera.${base_domain}":
        proxy_url  => "http://localhost:${tessera::params::port}",
        access_log => "${approot}/logs/tessera-nginx-access.log",
        error_log  => "${approot}/logs/tessera-nginx-error.log",
        static_dirs        => {
            "/static/"     => "${approot}/code/tessera/static/",
        }
    }
}