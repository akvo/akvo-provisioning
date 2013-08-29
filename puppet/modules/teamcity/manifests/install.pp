class teamcity::install {
    $version = '8.0.2'
    $url = "http://download.jetbrains.com/teamcity/TeamCity-${version}.tar.gz"
    $tarball = "/opt/teamcity/tarballs/teamcity-${version}.tar.gz"
    $unpackdir = "/opt/teamcity/versions/${version}/"

    $mysql_file = "mysql-connector-java-5.1.26.tar.gz"
    $mysql_jar_url = "http://cdn.mysql.com/Downloads/Connector-J/${mysql_file}"

    file { ['/opt/teamcity/tarballs/', '/opt/teamcity/versions', $unpackdir]:
        ensure  => 'directory',
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => 750,
        require => File['/opt/teamcity'],
    }

    file { '/opt/teamcity/TeamCity':
        ensure  => link,
        target  => "${unpackdir}/TeamCity",
        require => Exec['unpack_teamcity']
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
        command => '/opt/teamcity/install.sh',
        user    => 'teamcity',
        cwd     => '/opt/teamcity',
        creates => "/opt/teamcity/versions/${version}",
        require => File['/opt/teamcity/install.sh']
    }

}