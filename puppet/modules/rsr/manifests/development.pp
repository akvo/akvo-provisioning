
class rsr::development ( $enabled = false ) {

    if ( $enabled ) {
        include rsr::params
        $approot = $rsr::params::approot

        # we need unzip to handle the dev db
        package { 'unzip':
            ensure => installed
        }

        # include the dev db installation script
        file { "${approot}/install_test_db.sh":
            ensure => 'present',
            source => 'puppet:///modules/rsr/install_test_db.sh',
            owner  => 'rsr',
            mode   => '0755'
        }

    }

}