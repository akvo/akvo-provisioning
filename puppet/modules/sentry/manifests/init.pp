
class sentry inherits sentry::params {

    class { 'sentry::install': } ->
    class { 'sentry::config': } ~>
    class { 'sentry::service': } ->
    Class['sentry']

}