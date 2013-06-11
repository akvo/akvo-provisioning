
define akvoapp::app (
    $appname = undef
) {

    if ( !$appname ) {
        $appnameval = $name
    } else {
        $appnameval = $appname
    }


    # create our user
    user { $appnameval:
        ensure => present,
        home   => "/var/akvo/${appnameval}",
        shell  => '/bin/bash',
    }

    group { $appnameval:
        ensure  => present,
        require => User[$appnameval],
    }


    # make the directory that we'll use as the 'base'
    file { "/var/akvo/${appnameval}":
        ensure  => directory,
        owner   => $appnameval,
        group   => $appnameval,
        mode    => 755,
        require => [ User[$appnameval], Group[$appnameval], File['/var/akvo/'] ],
    }

    # make the directory that we'll use for checkouts
    file { "/var/akvo/${appnameval}/git/":
        ensure  => directory,
        owner   => $appnameval,
        group   => $appnameval,
        mode    => 755,
        require => [ User[$appnameval], Group[$appnameval], File["/var/akvo/${appnameval}"] ],
    }

    # we need somewhere for logging to
    file { "/var/akvo/${appnameval}/logs":
        ensure  => 'directory',
        owner   => $appnameval,
        group   => $appnameval,
        mode    => 755,
        require => [ User[$appnameval], Group[$appnameval], File["/var/akvo/${appnameval}"] ],
    }


    # TODO: deploy SSH key also goes in this class

}