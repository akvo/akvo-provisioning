define rsr::user ( $username, $approot ) {

    # create our user
    user { $username:
        ensure => present,
        home   => $approot,
        shell  => '/bin/bash',
    }

    group { $username:
        ensure  => present,
        require => User[$username],
    }

}