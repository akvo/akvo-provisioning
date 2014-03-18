
class statsd::config {

    $graphite_host = hiera('graphite_host')

    file { '/opt/statsd/config.js':
        ensure  => present,
        owner   => 'statsd',
        group   => 'statsd',
        mode    => '0400',
        content => template('statsd/config.js.erb'),
        require => Exec['clone_statsd'],
    }

    $base_domain = hiera('base_domain')
    nginx::proxy { "statsd.${base_domain}":
        proxy_url          => "http://localhost:8126",
    }

}