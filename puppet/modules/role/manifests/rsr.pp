class role::rsr {
    notice("Including role: RSR")

    #if ( $::environment == 'localdev_rsr' ) {
    #    include rsr::development
    #} else {
        include rsr::installed
    #}

}