# this class represents a locally-developed copy of RSR, which is to
# be used when developing RSR on a local vagrant machine

class rsr::development {
    include rsr::common

    # add the watcher script
    file { '/var/akvo/rsr/observe_rsr.sh':
        ensure => 'present',
        source => 'puppet:///modules/rsr/observe_rsr.sh',
        owner  => 'rsr',
        mode   => '744',
        notify => Class['Supervisord::Update'],
    }

    # start the watchdog process to keep an eye for changes
    supervisord::service { "rsr_reload":
        user      => 'rsr',
        command   => "/bin/bash /var/akvo/rsr/observe_rsr.sh",
        directory => "/var/akvo/rsr/",
        require   => File['/var/akvo/rsr/observe_rsr.sh'],
    }


    # link in our media which is kind of static
    file { "${media_root}/akvo":
        ensure  => 'link',
        target  => '/var/akvo/rsr/git/current/akvo/mediaroot/akvo',
        require => File[$media_root],
    }
    file { "${media_root}/core":
        ensure  => 'link',
        target  => '/var/akvo/rsr/git/current/akvo/mediaroot/core',
        require => File[$media_root],
    }
    file { "${media_root}/widgets":
        ensure  => 'link',
        target  => '/var/akvo/rsr/git/current/akvo/mediaroot/widgets',
        require => File[$media_root],
    }

}