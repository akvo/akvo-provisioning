class butler::user {

    include butler::params
    $username = $butler::params::username
    $approot = $butler::params::approot

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

    ssh_authorized_key { "butler-deploy_key":
        ensure  => present,
        key     => hiera('butler-deploy_public_key'),
        type    => 'ssh-rsa',
        user    => 'butler',
        require => File["${approot}/.ssh"]
    }

}