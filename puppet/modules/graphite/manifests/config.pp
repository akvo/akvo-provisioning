
class graphite::config {

    debug("Configuring Graphite")

    file { '/opt/graphite/conf/storage-schemas.conf':
        ensure  => present,
        source  => 'puppet:///modules/graphite/storage-schemas.conf',
        owner   => 'graphite',
        group   => 'graphite',
        mode    => '444',
    }

    file { '/opt/graphite/conf/carbon.conf':
        ensure  => present,
        source  => 'puppet:///modules/graphite/carbon.conf',
        owner   => 'graphite',
        group   => 'graphite',
        mode    => '444',
    }

    $secret_key = hiera('graphite_secret_key')
    $database_host = hiera('graphite_database_host')
    $database_name = hiera('graphite_database_name')
    $database_user = hiera('graphite_database_user')
    $database_password = hiera('graphite_database_password')

    database::my_sql::db { $database_user:
        password => $database_password
    }

    file { '/opt/graphite/webapp/graphite/local_settings.py':
        ensure  => present,
        owner   => 'graphite',
        group   => 'graphite',
        mode    => 444,
        content => template('graphite/graphite_settings.py.erb'),
    }


    named::service_location { "graphite":
        ip => hiera('external_ip')
    }

    $base_domain = hiera('base_domain')
    nginx::proxy { "graphite.${base_domain}":
        proxy_url          => "http://localhost:5115",
    }

}