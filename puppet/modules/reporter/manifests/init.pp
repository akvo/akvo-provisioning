
class reporter inherits reporter::params {

    class { 'reporter::install': } ->
    class { 'reporter::config': } ~>
    class { 'reporter::service': } ->
    Class['reporter']

}