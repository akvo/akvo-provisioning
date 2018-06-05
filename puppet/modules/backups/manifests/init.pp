
class backups {

    user { 'backup':
        ensure => present,
        shell  => '/bin/sh',
        home   => '/backups',
    }

    group { 'backup':
        ensure => present,
    }

    package { 'lftp':
        ensure => 'present'
    }

    file { ['/backups', '/backups/bin', '/backups/data', '/backups/ssh', '/backups/logs']:
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0770',
        require => User['backup'],
    }

    file { '/backups/encrypt_key':
        path    => hiera('db_crypto_file'),
        ensure  => present,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0600',
        content => hiera('db_crypto_password'),
        require => File['/backups']
    }

    file { '/backups/ssh/backup_key':
        ensure  => present,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0600',
        content => hiera('backup_private_key'),
        require => File['/backups/ssh']
    }

    ssh_authorized_key { 'backup-authorized-key':
        ensure  => present,
        key     => hiera('backup_public_key'),
        type    => 'ssh-rsa',
        user    => 'backup'
    }

    # export the backup key to any backup servers that we control
    @@ssh_authorized_key { "backup_key_${::hostname}":
        ensure  => present,
        key     => hiera('backup_public_key'),
        type    => 'ssh-rsa',
        user    => 'backupserver',
        tag     => 'backupserver'
    }

    # purge old config to avoid backing up to servers which no longer exist
    exec { 'clean_up_backup_config':
        command   => '/bin/rm -vf /backups/bin/*_backup_to_*.sh',
        logoutput => true,
    }
    create_resources('backups::server', hiera_hash('backup_servers'))

}
