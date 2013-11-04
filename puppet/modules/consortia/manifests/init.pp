
class consortia {

    $db_host = 'mysql'
    $db_password = hiera('consortia_database_password')

    $consortia_hostnames = hiera('consortia_hostnames')

    php::app { 'consortia':
        app_hostnames  => $consortia_hostnames,
        group          => 'www-edit',
        wordpress      => true,
        nginx_writable => true,
    }

    file { "/var/akvo/consortia/code/wp-config.php":
        ensure  => present,
        owner   => 'consortia',
        group   => 'consortia',
        mode    => '0444',
        content => template('consortia/wp-config.php.erb'),
        require => File["/var/akvo/consortia/code"]
    }

    database::my_sql::db { 'consortia':
        password => $db_password
    }

}