
class systemstats {

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

    systemstats::stat { [
        'packages_available',
        'restart_required',
    ]:
        user => 'root'
    }

}