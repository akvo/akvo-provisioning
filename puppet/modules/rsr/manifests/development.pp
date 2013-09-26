
class rsr::development ( $enabled = false ) {

    include rsr::params

    if ( $enabled ) {
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
    }

}