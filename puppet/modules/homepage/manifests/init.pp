
class homepage {

    $db_host = 'mysql'
    $db_password = hiera('homepage_wordpress_database_password')

    $specified_hostnames = hiera('homepage_hostnames')
    $base_domain = hiera('base_domain')
    $default_hostname = ["homepage.${base_domain}"]
    $homepage_hostnames = concat($default_hostname, $specified_hostnames)

    php::app { 'homepage':
        app_hostnames  => $homepage_hostnames,
        group          => 'www-edit',
        wordpress      => true,
        nginx_writable => true,
    }

    file { "/var/akvo/homepage/code/wp-config.php":
        ensure  => present,
        owner   => 'homepage',
        group   => 'homepage',
        mode    => '0444',
        content => template('homepage/wp-config.php.erb'),
        require => File["/var/akvo/homepage/code"]
    }

    database::my_sql::db { 'homepage':
        password => $db_password
    }

    named::service_location { 'homepage':
        ip => hiera('external_ip')
    }

}
