
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
        require => File[$unpackdir],
    }

}