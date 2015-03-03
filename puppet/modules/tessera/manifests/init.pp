
class tessera inherits tessera::params {

    class { 'tessera::install': } ->
    class { 'tessera::config': } ~>
    class { 'tessera::service': } ->
    Class['tessera']

}