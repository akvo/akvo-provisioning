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
        mode    => '0700',
        require => User['teamcity'],
    }

    group { 'teamcity':
        ensure => 'present',
    }

    file { '/opt/teamcity':
        ensure  => 'directory',
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => '0750',
        require => [ User['teamcity'], Group['teamcity'] ],
    }

    Teamcity::Deploykey<<||>>

}