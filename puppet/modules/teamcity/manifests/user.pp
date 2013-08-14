class teamcity::user {

    user { 'teamcity':
        ensure => 'present',
        home   => '/opt/teamcity/',
        shell  => '/bin/bash',
    }

    file { '/opt/teamcity/.ssh':
        ensure  => directory,
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => 700,
        require => User['teamcity'],
    }

#    file { '/opt/teamcity/.ssh/known_hosts':
#        ensure  => present,
#        owner   => 'teamcity',
#        group   => 'teamcity',
#        mode    => 644,
#        source  => 'puppet:///modules/teamcity/known_hosts',
#        require => File['/opt/teamcity/.ssh']
#    }

    group { 'teamcity':
        ensure => 'present',
    }

    file { '/opt/teamcity':
        ensure  => 'directory',
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => 750,
        require => [ User['teamcity'], Group['teamcity'] ],
    }

}