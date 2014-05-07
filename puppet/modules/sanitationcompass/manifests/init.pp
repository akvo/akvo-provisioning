
/*
   TODO: watercompass and sanitationcompass are very similar, so they could be combined
 */
class sanitationcompass
inherits sanitationcompass::params {

    class { 'sanitationcompass::install': } ->
    class { 'sanitationcompass::config': } ~>
    class { 'sanitationcompass::service': } ->
    Class['sanitationcompass']

}
