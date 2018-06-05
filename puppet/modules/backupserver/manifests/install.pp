
class backupserver::install {

    user { 'backupserver':
        ensure => 'present',
        home   => '/backupserver'
    }

    group { 'backupserver':
        ensure => 'present'
    }

    file { '/backupserver':
        ensure => directory,
        owner  => 'backupserver',
        group  => 'backupserver',
        mode   => '0700'
    }

    file { '/backupserver/data/':
        ensure  => directory,
        owner   => 'backupserver',
        group   => 'backupserver',
        mode    => '0700',
        require => File['/backupserver']
    }

    $db_crypto_file = hiera('db_crypto_file')
    file { '/backups/encrypt_key':
        path    => hiera('db_crypto_file'),
        ensure  => present,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0600',
        content => hiera('db_crypto_password'),
        require => File['/backups']
    }

    file { '/backupserver/decrypt.sh':
        ensure  => present,
        owner   => 'backupserver',
        group   => 'backupserver',
        mode    => '0700',
        content => template('backupserver/decrypt.sh.erb'),
        require => File['/backupserver']
    }

    file { '/backupserver/.ssh':
        ensure  => directory,
        owner   => 'backupserver',
        group   => 'backupserver',
        mode    => '0700',
        require => File['/backupserver'],
    }

    file { '/backupserver/.ssh/authorized_keys':
        ensure  => present,
        owner   => 'backupserver',
        group   => 'backupserver',
        mode    => '0600',
        require => File['/backupserver/.ssh'],
    }

    # let everyone know where we are
    named::service_location { 'backupserver':
        ip => hiera('external_ip')
    }

    # collect any exported keys
    Ssh_authorized_key <<| tag == 'backupserver' |>>

}