class unilog {

    class { 'unilog::install': } ->
    class { 'unilog::config': } ~>
    class { 'unilog::service': } ->
    Class['unilog']

}
