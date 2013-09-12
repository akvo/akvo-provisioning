
class statsd::config {

    file { '/opt/statsd/config.js':
        ensure  => present,
        owner   => 'statsd',
        group   => 'statsd',
        mode    => 400,
        content => template('statsd/config.js.erb'),
        require => Exec['clone_statsd'],
    }

    named::service_location { "statsd":
        ip => hiera('external_ip')
    }

    $base_domain = hiera('base_domain')
    nginx::proxy { "statsd.${base_domain}":
        proxy_url          => "http://localhost:8126",
    }

}