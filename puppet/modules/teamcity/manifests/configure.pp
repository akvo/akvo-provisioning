
class teamcity::configure {

    listen_address = '127.0.0.1'
    file { '/opt/teamcity/TeamCity/conf/server.xml':
        ensure  => present,
        owner   => teamcity,
        group   => teamcity,
        content => template('teamcity/server.xml.erb'),
        mode    => 644,
        notify  => Class['teamcity::reload']
    }

}