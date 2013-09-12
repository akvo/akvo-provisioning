
class graphite::install {

    debug("Installing Graphite")

    include pythonsupport::standard
    include pythonsupport::mysql
    include pythonsupport::pycairo

    user { 'graphite':
        ensure => present,
        shell  => '/bin/bash',
        home   => '/opt/graphite',
    }

    group { 'graphite':
        ensure => present,
    }

    file { '/opt/graphite':
        ensure  => directory,
        owner   => 'graphite',
        group   => 'graphite',
        mode    => 700,
        require => User['graphite']
    }

    package { 'python-cairo': # becuase pycairo doesn't have a setup.py so can't be installed by pip..
        ensure  => installed,
        require => Class['pythonsupport::pycairo']
    }

    file { '/opt/graphite/install.sh':
        ensure  => present,
        owner   => 'graphite',
        mode    => 500,
        source  => 'puppet:///modules/graphite/install_graphite.sh',
        require => File['/opt/graphite'],
    }

    exec { 'install-graphite':
        command => '/bin/bash /opt/graphite/install.sh',
        user    => 'graphite',
        creates => '/opt/graphite/.installed',
        require => File['/opt/graphite/install.sh']
    }

}