# this class represents a locally-developed copy of RSR, which is to
# be used when developing RSR on a local vagrant machine

class rsr::development {
    include rsr::common
    $approot = $rsr::common::approot

    # add the watcher script
    file { "${approot}/observe_rsr.sh":
        ensure => 'present',
        source => 'puppet:///modules/rsr/observe_rsr.sh',
        owner  => 'rsr',
        mode   => '744',
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