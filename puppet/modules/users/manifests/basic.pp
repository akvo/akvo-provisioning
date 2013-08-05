define users::basic (
    $username = undef,
    $role,
    $ssh_key,
    $ssh_type = 'ssh-rsa',
    $htpasswd = undef
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
        password => '$6$w2FK/jnb$9KqSVzM1ha2rPMF8SfLayCIrnkqqyRSSSvVTPQEUTBa46Hd2AcoSDuyzsywWTyCpb7guoHn.on/08qJW1IhGJ.',
    }

    group { $usernameval:
        require => User[$usernameval]
    }

    file { "/home/${usernameval}/":
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
        key     => $ssh_key,
        type    => $ssh_type,
        user    => $usernameval,
        require => File["/home/${usernameval}/.ssh/authorized_keys"]
    }

    if ( $htpasswd ) {
        htpasswd::user { $usernameval:
            user     => $usernameval,
            role     => $role,
            password => $htpasswd
        }
    }

}
