
class common::stats {

    user { 'stats':
        ensure => present,
        shell => '/bin/bash',
        home => '/var/stats',
    }

    group { 'stats':
        ensure => present,
    }

    file { ['/var/stats', '/var/stats/bin/']:
        ensure => directory,
        owner => 'stats',
        mode => '755',
        require => User['stats'],
    }

    common::stats_sender { [
        'packages_available',
        'restart_required',
    ]: }

}