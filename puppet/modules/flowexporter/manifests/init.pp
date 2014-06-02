
class flowexporter (
    $develop_mode = false
) inherits flowexporter::params {

    class { 'flowexporter::install': } ->
    class { 'flowexporter::config': } ~>
    class { 'flowexporter::service': } ->
    Class['flowexporter']

}