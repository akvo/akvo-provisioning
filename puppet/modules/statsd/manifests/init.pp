
class statsd {

    class { 'statsd::install': } ->
    class { 'statsd::config': } ~>
    class { 'statsd::service': } ->
    Class['statsd']

}