
class backups {

    user { 'backup':
        ensure => present,
        shell => '/bin/sh',
    }

    file { '/backups': {
        ensure => directory,

    }

}