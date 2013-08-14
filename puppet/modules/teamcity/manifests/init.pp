
class teamcity {

    $version = '8.0.2'
    $url = "http://download.jetbrains.com/teamcity/TeamCity-${version}.tar.gz"
    $tarball = "/opt/teamcity/tarballs/teamcity-${version}.tar.gz"
    $unpackdir = "/opt/teamcity/versions/${version}/"

    include teamcity::packages
    include teamcity::user

    exec { 'fetch_teamcity':
        command => "/usr/bin/wget --output-document ${tarball} ${url}",
        creates => $tarball,
        user    => 'teamcity',
        cwd     => "/opt/teamcity/",
        require => [File['/opt/teamcity/tarballs/'], User['teamcity']],
    }

    file { ['/opt/teamcity/tarballs/', '/opt/teamcity/versions', $unpackdir]:
        ensure  => 'directory',
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => 750,
        require => File['/opt/teamcity'],
    }

    exec { 'unpack_teamcity':
        command => "/bin/tar -xzvf ${tarball} -C ${unpackdir}",
        creates => "${unpackdir}/TeamCity",
        user    => 'teamcity',
        cwd     => "/opt/teamcity",
        require => [Exec['fetch_teamcity'], File[$unpackdir]],
    }

    file { '/opt/teamcity/TeamCity':
        ensure  => link,
        target  => "${unpackdir}/TeamCity",
        require => Exec['unpack_teamcity']
    }

    $listen_address = '127.0.0.1'
    file { '/opt/teamcity/TeamCity/conf/server.xml':
        ensure  => present,
        owner   => teamcity,
        group   => teamcity,
        content => template('teamcity/server.xml.erb'),
        mode    => 644,
        require => Exec['unpack_teamcity'],
        notify  => Supervisord::Restart['teamcity_server']
    }


    include supervisord

    supervisord::service { "teamcity_server":
        user      => 'teamcity',
        command   => "/opt/teamcity/TeamCity/bin/teamcity-server.sh run",
        directory => '/opt/teamcity/TeamCity',
    }
    # we want the rsr user to be able to restart the process
    sudo::service_control { "teamcity_server":
        user         => 'teamcity',
    }

}