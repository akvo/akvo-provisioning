
class teamcity {

    $version = '8.0.2'
    $url = "http://download.jetbrains.com/teamcity/TeamCity-${version}.tar.gz"
    $dest = "/opt/teamcity-${version}.tar.gz"

    include teamcity::packages
    include teamcity::user

    exec { 'fetch_teamcity':
        command => "/usr/bin/wget --output-document ${dest} ${url}",
        creates => $dest,
        user    => 'teamcity',
        cwd     => "/opt/",
        require => [File['/opt/teamcity'], User['teamcity']],
    }



}