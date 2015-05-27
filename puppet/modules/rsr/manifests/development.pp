class rsr::development ( $enabled = false ) {

    if ( $enabled ) {
        # we need unzip to handle the dev db
        package { 'unzip':
            ensure => installed
        }
    }

}
