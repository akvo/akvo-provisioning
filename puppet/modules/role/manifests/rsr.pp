class role::rsr {
    notice("Including role: RSR")

    if ( $::environment == 'localdev' ) {
        include rsr::development
    } else {
        include rsr::installed
    }

}