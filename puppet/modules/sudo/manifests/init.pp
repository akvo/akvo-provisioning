class sudo {

    package { 'sudo':
        ensure => installed,
    }

    file { '/etc/sudoers':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => 440,
        source  => 'puppet:///modules/sudo/sudoers',
        require => Package['sudo'],
    }


    # for vagrant boxen, we want to leave the vagrant user in the same
    # state as the default, namely, full sudo access without needing a
    # password
    if ( $::environment == 'localdev' ) {
        sudo::admin_user { 'vagrant':
            nopassword => true
        }
    }

}