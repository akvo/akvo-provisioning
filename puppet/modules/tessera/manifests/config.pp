
class tessera::config inherits tessera::params {

    # create an butler database on the database server
    database::my_sql::db { $dbname:
        password   => $database_password,
        reportable => false
    }

    # we want a service address
    named::service_location { 'tessera':
        ip => hiera('external_ip')
    }

    # nginx sits in front of butler
    $base_domain = hiera('base_domain')
        nginx::proxy { "tessera.${base_domain}":
        proxy_url  => "http://localhost:${port}",
        access_log => "${approot}/logs/tessera-nginx-access.log",
        error_log  => "${approot}/logs/tessera-nginx-error.log",
        static_dirs        => {
            "/static/"     => "${approot}/code/tessera/static/",
        }
    }

    # tessera config file

    file { "${approot}/config.py":
        ensure => present,
        owner => 'tessera',
        group => 'tessera',
        mode => '0400',
        content => template('tessera/tessera_config.py.erb')

    }
}