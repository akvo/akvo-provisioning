# This class creates the structure necessary for running an Akvo app. It
# is the place to collect together things required by all Akvo hosted applications

class akvoapp {

    group { 'akvoapp':
        ensure => 'present'
    }

    file { '/apps':
        ensure  => directory,
        owner   => 'root',
        group   => 'akvoapp',
        mode    => 555,
        require => Group['akvoapp'],
    }

}