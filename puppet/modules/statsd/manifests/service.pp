
class statsd::service {

    supervisord::service { 'statsd':
        user      => 'statsd',
        command   => 'node stats.js /opt/statsd/config.js',
        directory => '/opt/statsd'
    }

}