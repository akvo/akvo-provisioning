
class teamcity::packages {

    package { ['ant', 'openjdk-7-jdk']:
        ensure => latest
    }

}