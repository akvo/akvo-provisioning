
class teamcity::packages {

    package { ['ant', 'openjdk-7-jdk', 'maven']:
        ensure => latest
    }

    include javasupport::gae
    class { 'javasupport::leiningen':
        user         => 'teamcity',
        install_path => '/opt/teamcity/'
    }

}
