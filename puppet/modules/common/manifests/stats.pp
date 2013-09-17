
class common::stats {

    user { 'stats':
        ensure => present,
        shell => '/bin/bash',
        home => '/etc/stats',
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

    $statsd_host = hiera('statsd_host')

    file { '/var/stats/bin/packages_available.sh':
        ensure  => present,
        owner   => 'stats',
        mode    => 744,
        require => File['/var/stats/bin'],
        content => template('common/packages_available.sh.erb')
    }

    file { '/var/stats/bin/restart_required.sh':
        ensure  => present,
        owner   => 'stats',
        mode    => 744,
        require => File['/var/stats/bin'],
        content => template('common/restart_required.sh.erb')
    }

}