
class rsr::development ( $enabled = false ) {

    if ( $enabled ) {
        include rsr::params
        $approot = $rsr::params::approot

        # add the watcher script
        file { "${approot}/observe_rsr.sh":
            ensure => 'present',
            source => 'puppet:///modules/rsr/observe_rsr.sh',
            owner  => 'rsr',
            mode   => '0744',
            notify => Class['Supervisord::Update'],
        }

        # start the watchdog process to keep an eye for changes
        supervisord::service { "rsr_reload":
            user      => 'rsr',
            command   => "/bin/bash ${approot}/observe_rsr.sh",
            directory => $approot,
            require   => File["${approot}/observe_rsr.sh"],
        }

        # we need unzip to handle the dev db
        package { 'unzip':
            ensure => installed
        }

        # include the dev db installation script
        file { '/usr/local/bin/install_test_db.sh':
            ensure => 'present',
            source => 'puppet:///modules/rsr/install_test_db.sh',
            owner  => 'root',
            mode   => '0755'
        }

    }

}