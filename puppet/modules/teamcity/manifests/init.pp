
class teamcity {

    $version = '8.0.2'
    $url = "http://download.jetbrains.com/teamcity/TeamCity-${version}.tar.gz"
    $dest = "/opt/teamcity/tarballs/teamcity-${version}.tar.gz"

    include teamcity::packages
    include teamcity::user

    exec { 'fetch_teamcity':
        command => "/usr/bin/wget --output-document ${dest} ${url}",
        creates => $dest,
        user    => 'teamcity',
        cwd     => "/opt/teamcity/tarballs/",
        require => [File['/opt/teamcity/tarballs/'], User['teamcity']],
    }

    file { '/opt/teamcity/tarballs/':
        ensure  => 'directory',
        owner   => 'teamcity',
        group   => 'teamcity',
        mode    => 750,
        require => File['/opt/teamcity'],
    }



}