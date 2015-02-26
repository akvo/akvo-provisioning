
class rsr::development ( $enabled = false ) {

    if ( $enabled ) {
        include rsr::params
        $approot = $rsr::params::approot

        # we need unzip to handle the dev db
        package { 'unzip':
            ensure => installed
        }
    }

}