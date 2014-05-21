
class butler (
    $develop_mode = false
) inherits butler::params {

    class { 'butler::install': } ->
    class { 'butler::config': } ~>
    class { 'butler::service': } ->
    Class['butler']

}