
class butler::config {

    include butler::params
    $approot = $butler::params::approot

    # create an butler database on the database server
    database::my_sql::db { $butler::params::dbname:
        password   => $butler::params::database_password,
        reportable => false
    }

    # we want a service address
    named::service_location { "butler":
        ip => hiera('external_ip')
    }

    # nginx sits in front of butler
    $base_domain = hiera('base_domain')
    nginx::proxy { "butler.${base_domain}":
        proxy_url  => "http://localhost:${butler::params::port}",
        access_log => "${approot}/logs/butler-nginx-access.log",
        error_log  => "${approot}/logs/butler-nginx-error.log",
        static_dirs        => {
            "/static/"     => "${media_root}/static",
            "/media/"      => "${media_root}/media",
        }
    }


    # let the build server know how to log in to us
    @@teamcity::deploykey { "butler-${::environment}":
        service     => 'butler',
        environment => $::environment,
        key         => hiera('butler-deploy_private_key'),
    }

}