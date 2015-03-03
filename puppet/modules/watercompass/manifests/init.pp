
/*
   TODO: watercompass and watercompass are very similar, so they could be combined
 */
class watercompass
inherits watercompass::params {

    class { 'watercompass::install': } ->
    class { 'watercompass::config': } ~>
    class { 'watercompass::service': } ->
    Class['watercompass']

}
