
define akvoapp::app (
    $appname = nil
) {

    if ( !$appname ) {
        $appnameval = $name
    } else {
        $appnameval = $appname
    }


    # create our user
    user { $appnameval:
        ensure => present,
        home   => "/apps/${appnameval}",
        shell  => '/bin/bash',
    }

    group { $appnameval:
        ensure  => present,
        require => User[$appnameval],
    }


    # make the directory that we'll use as the 'base'
    file { "/apps/${appnameval}":
        ensure  => directory,
        owner   => $appnameval,
        group   => $appnameval,
        mode    => 500,
        require => [ User[$appnameval], Group[$appnameval], File['/apps'] ],
    }

    # TODO: deploy SSH key also goes in this class

}