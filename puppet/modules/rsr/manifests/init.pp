
class rsr inherits rsr::params {

    class { 'rsr::install': } ->
    class { 'rsr::development': enabled => $develop_mode } ->
    class { 'rsr::config': } ~>
    class { 'rsr::service': } ->
    Class['rsr']

}