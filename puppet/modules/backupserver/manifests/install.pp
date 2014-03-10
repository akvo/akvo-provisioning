
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
        mode   => '0500'
    }

    file { '/backupserver/data/':
        ensure  => directory,
        owner   => 'backupserver',
        group   => 'backupserver',
        mode    => '0700',
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

    # collect any exported keys
    Ssh_authorized_key <<| tag == 'backupserver' |>>

}