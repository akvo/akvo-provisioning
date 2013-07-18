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

    file { "${approot}/.ssh":
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => 700,
        require => File[$approot],
    }

    ssh_authorized_key { "rsr-deploy_key":
        ensure  => present,
        key     => hiera('rsr-deploy_public_key'),
        type    => 'ssh-rsa',
        user    => 'rsr',
        require => File["${approot}/.ssh"]
    }

}