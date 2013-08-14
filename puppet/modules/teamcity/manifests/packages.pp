
class teamcity::packages {

    $packages = [
        "openjdk-7-jdk",
    ]

    package { $packages:
        ensure => latest
    }

}