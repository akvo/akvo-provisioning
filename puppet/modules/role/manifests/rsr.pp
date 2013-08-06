class role::rsr {
    notice("Including role: RSR")

    if ( str2bool(hiera('rsr_development')) ) {
        include rsr::development
    } else {
        include rsr::installed
    }

}