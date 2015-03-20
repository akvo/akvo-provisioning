class opendata inherits opendata::params {

    class { 'opendata::install': } ->
    class { 'opendata::config': } ~>
    class { 'opendata::service': } ->
    Class['opendata']

}
