
class teamcity::packages {

    package { ['ant', 'openjdk-7-jdk', 'maven']:
        ensure => latest
    }

    include clojuresupport::leiningen

}