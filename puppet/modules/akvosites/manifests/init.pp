
class akvosites {

    $db_host = 'mysql'
    $db_password = hiera('akvosites_database_password')

    $akvosites_hostnames = hiera('akvosites_hostnames')
    $app_path = '/var/akvo/akvosites'

    package { 'php5-gd':
        ensure  => installed,
        require => Package['php5-fpm'],
        notify  => Service['php5-fpm']
    }

    php::app { 'akvosites':
        app_hostnames        => $akvosites_hostnames,
        group                => 'www-edit',
        wordpress            => true,
        nginx_writable       => true,
        config_file_contents => template('akvosites/akvosites-nginx.conf.erb')
    }

    file { "/var/akvo/akvosites/code/wp-config.php":
        ensure  => present,
        owner   => 'akvosites',
        group   => 'akvosites',
        mode    => '0444',
        content => template('akvosites/wp-config.php.erb'),
        require => File["/var/akvo/akvosites/code"]
    }

    database::my_sql::db { 'akvosites':
        password   => $db_password,
        reportable => true
    }

    named::service_location { 'akvosites':
        ip => hiera('external_ip')
    }

}