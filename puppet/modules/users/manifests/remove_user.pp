
define users::remove_user(
    $username = undef
) {
    if ( $username ) {
        $usernameval = $username
    } else {
        $usernameval = $name
    }

    user { $usernameval:
        ensure => absent
    }

    file { "/home/${usernameval}":
        ensure => absent,
        force  => true,
    }

    # TODO: needs to remove htpasswds too

}