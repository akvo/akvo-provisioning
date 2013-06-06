class role::rsr {
    notice("Including role: RSR")

    if ( $::environment == 'dev_rsr' ) {
        include rsr::development
    } else {
        include rsr::installed
    }

}