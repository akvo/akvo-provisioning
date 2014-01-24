define akvoapp::user ($deploy_key = undef) {

    $username = $name
    $approot = "/var/akvo/${name}"

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

    file { "${approot}/.ssh":
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0700',
        require => File[$approot],
    }

    if ( $deploy_key ) {
        ssh_authorized_key { "${username}-deploy_key":
            ensure  => present,
            key     => $deploy_key,
            type    => 'ssh-rsa',
            user    => $username,
            require => File["${approot}/.ssh"]
        }
    }

}