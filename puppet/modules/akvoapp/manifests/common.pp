
class akvoapp::common {

    group { ['akvoapp', 'www-data']:
        ensure => 'present'
    }

    file { '/var/akvo/':
        ensure  => directory,
        owner   => 'root',
        group   => 'akvoapp',
        mode    => '0555',
        require => Group['akvoapp'],
    }

}