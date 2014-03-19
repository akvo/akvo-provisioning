class teamcity::install {
    $version = '8.1.1'
    $unpackdir = "/opt/teamcity/versions/${version}/"

    file { ['/opt/teamcity/tarballs/', '/opt/teamcity/versions', $unpackdir]:
        ensure  => 'directory',
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => '0750',
        require => File['/opt/teamcity'],
    }

    file { '/opt/teamcity/TeamCity':
        ensure  => link,
        target  => "${unpackdir}/TeamCity",
    }

    file { '/opt/teamcity/install.sh':
        ensure  => present,
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => '700',
        content => template('teamcity/install.sh.erb'),
        require => File['/opt/teamcity'],
    }

    exec { 'install-teamcity':
        command => "/opt/teamcity/install.sh ${version}",
        user    => 'teamcity',
        cwd     => '/opt/teamcity',
        creates => "/opt/teamcity/versions/${version}",
        require => File['/opt/teamcity/install.sh'],
        timeout => 0,
    }

}