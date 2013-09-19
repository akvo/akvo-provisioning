
class graphite {

    notice('Graphite')

    class { 'graphite::install': } ->
    class { 'graphite::config': } ~>
    class { 'graphite::service': } ->
    Class['graphite']

}