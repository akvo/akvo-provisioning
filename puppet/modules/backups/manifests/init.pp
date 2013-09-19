
class backups {

    user { 'backup':
        ensure => present,
        shell  => '/bin/sh',
        home   => '/backups',
    }

    group { 'backup':
        ensure => present,
    }

    file { ['/backups', '/backups/bin', '/backups/data', '/backups/ssh']:
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0770',
        require => User['backup'],
    }

    file { "/backups/ssh/backup_key":
        ensure  => present,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0600',
        content => hiera('backup_private_key'),
        require => File['/backups/ssh']
    }

    create_resources("backups::server", hiera('backup_servers'))

}