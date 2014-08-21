
class homepage {

    class { 'homepage::install': } ->
    class { 'homepage::config': } ~>
    class { 'homepage::service': } ->
    Class['homepage']

}
