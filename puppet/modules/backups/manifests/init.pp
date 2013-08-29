
class backups {

    user { 'backup':
        ensure => present,
        shell  => '/bin/sh',
        home   => '/backups',
    }

    group { 'backup':
        ensure => present,
    }

    file { ['/backups', '/backups/bin']:
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        mode    => 770,
        require => User['backup'],
    }

}