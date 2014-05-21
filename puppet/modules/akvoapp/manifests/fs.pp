define akvoapp::fs (
    $deploy_key = undef
) {

    $username = $name
    $approot = "/var/akvo/${username}"

    akvoapp::user { $username:
        deploy_key => $deploy_key
    }

    # make the directory that we'll use as the 'base'
    file { $approot:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => [ User[$username], Group[$username], File['/var/akvo/'] ],
    }

    file { "${approot}/logs":
        ensure  => directory,
        owner   => $username,
        group   => 'www-data',
        mode    => '0775',
        require => [ Group['www-data'], File[$approot] ],
    }

}