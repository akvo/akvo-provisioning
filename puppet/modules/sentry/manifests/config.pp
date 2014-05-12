
class sentry::config {

    $port = $sentry::port
    $db_name = $sentry::db_name
    $db_username = $sentry::db_username
    $db_password = $sentry::db_password
    $secret_key = $sentry::secret_key

    $base_domain = hiera('base_domain')
    $url_prefix = "http://sentry.${base_domain}"

    file { '/opt/sentry/conf.py':
        ensure  => present,
        owner   => 'sentry',
        group   => 'sentry',
        mode    => '0500',
        content => template('sentry/sentry.conf.erb'),
        require => File['/opt/sentry']
    }

    database::my_sql::db { $db_username:
        password => $db_password
    }

    named::service_location { 'sentry':
        ip => hiera('external_ip')
    }

    nginx::proxy { "sentry.${base_domain}":
        proxy_url => "http://localhost:${port}",
        htpasswd => false
    }

}