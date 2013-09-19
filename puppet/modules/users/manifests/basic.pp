define users::basic (
    $username = undef,
    $roles = [],
    $allow = [],
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
        groups   => $roles,
    }

    file { "/home/${usernameval}/.bash_login":
        ensure  => present,
        owner   => $usernameval,
        group   => $usernameval,
        mode    => '0700',
        source  => 'puppet:///modules/users/set_pass_if_empty.sh',
        require => File["/home/${usernameval}"],
    }

    exec { "/usr/bin/passwd --delete ${usernameval}":
        onlyif  => "/bin/egrep -q '^${usernameval}:[*!]' /etc/shadow",
        require => User[$usernameval];
    }

    group { $usernameval:
        require => User[$usernameval]
    }

    file { "/home/${usernameval}/":
        ensure => directory,
        owner => $usernameval,
        group => $usernameval,
        mode => '0750',
        require => [ User[$usernameval], Group[$usernameval] ],
    }

    file { "/home/${usernameval}/.ssh":
        ensure => directory,
        owner => $usernameval,
        group => $usernameval,
        mode => '0700',
        require => File["/home/${usernameval}/"],
    }

    file { "/home/${usernameval}/.ssh/authorized_keys":
        ensure => present,
        owner => $usernameval,
        group => $usernameval,
        mode => '0600',
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
            allow    => $allow,
            password => $htpasswd
        }
    }

}
