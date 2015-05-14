
class homepage::config inherits homepage::params {

    file { "${appdir}/wp-config.php":
        ensure  => present,
        owner   => $username,
        group   => $username,
        mode    => '0444',
        content => template('homepage/wp-config.php.erb'),
        require => File[$appdir]
    }

    @@teamcity::deploykey { "homepage-${::environment}":
        service     => 'homepage',
        environment => $::environment,
        key         => hiera('homepage-deploy_private_key'),
    }

    database::my_sql::db { 'homepage':
        mysql_name => $mysql_name,
        password   => $db_password,
        reportable => true
    }

    named::service_location { 'homepage':
        ip => hiera('external_ip')
    }

    backups::dir { 'homepage_media':
        path => "${appdir}/uploads"
    }

    backups::dir { 'homepage_data':
        path => "${appdir}/data"
    }

}
