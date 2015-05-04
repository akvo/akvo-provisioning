class opendata {

    class { 'opendata::install': } ->
    class { 'opendata::config': } ~>
    class { 'opendata::service': } ->
    Class['opendata']

}
