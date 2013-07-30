define users::basic (
    $username = undef,
    $role,
    $ssh_key,
    $htpasswd
) {

    if ( $username ) {
        $usernameval = $username
    } else {
        $usernameval = $name
    }

    user { $usernameval:
        ensure   => 'present',
        home     => "/home/${usernameval}",
        shell    => '/bin/bash',
        groups   => $role,
        require  => Group[$role],
    }

    group { $usernameval:
        require => User[$usernameval]
    }

    file { "/home/${usernameval}/':
        ensure => directory,
        owner => $usernameval,
        group => $usernameval,
        mode => 750,
        require => [ User[$usernameval], Group[$usernameval] ],
    }

    file { "/home/${usernameval}/.ssh":
        ensure => directory,
        owner => $usernameval,
        group => $usernameval,
        mode => 700,
        require => File["/home/${usernameval}/"],
    }

    file { "/home/${usernameval}/.ssh/authorized_keys":
        ensure => present,
        owner => $usernameval,
        group => $usernameval,
        mode => 600,
        require => File["/home/${usernameval}/.ssh"],
    }

    ssh_authorized_key { "${usernameval}_key":
        ensure  => present,
        key     => $sshkey,
        type    => 'ssh-rsa',
        user    => $usernameval,
        require => File["/home/${usernameval}/.ssh/authorized_keys"]
    }

    users::htpasswd { $usernameval:
        user     => $usernameval,
        role     => $role,
        password => $htpasswd
    }

}
