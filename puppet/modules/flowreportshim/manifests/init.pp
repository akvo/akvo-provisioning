
class flowreportshim (
    $develop_mode = false
) inherits flowreportshim::params {

    class { 'flowreportshim::install': } ->
    class { 'flowreportshim::config': } ~>
    class { 'flowreportshim::service': } ->
    Class['flowreportshim']

}