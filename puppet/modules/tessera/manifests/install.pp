
class tessera::install {

    include pythonsupport::standard
    include pythonsupport::mysql

    $approot = $tessera::params::approot

    user { 'tessera':
        ensure => present,
        shell  => '/bin/bash',
        home   => '/opt/tessera'
    }

    group { 'tessera':
        ensure => present
    }

    file { [$approot, "${approot}/logs"]:
        ensure  => directory,
        owner   => 'tessera',
        group   => 'tessera',
        mode    => '0755',
        require => User['tessera']
    }

    file { "${approot}/install.sh":
        ensure  => present,
        owner   => 'tessera',
        group   => 'tessera',
        mode    => '0700',
        source  => 'puppet:///modules/tessera/install_tessera.sh',
        require => File[$approot]
    }

    exec { "${approot}/install.sh":
        user    => 'tessera',
        creates => "${approot}/.installed",
        require => File["${approot}/install.sh"]
    }


}