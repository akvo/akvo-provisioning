
class sentry::install {

    include pythonsupport::standard
    include pythonsupport::psql
    
    user { 'sentry':
        ensure => present,
        shell  => '/bin/bash',
        home   => '/opt/sentry',
    }
    
    group { 'sentry':
        ensure => present,
    }
    
    file { '/opt/sentry':
        ensure  => directory,
        owner   => 'sentry',
        group   => 'sentry',
        mode    => 0700,
        require => User['sentry']
    }
    
    file { '/opt/sentry/install.sh':
        ensure  => present,
        owner   => 'sentry',
        mode    => 500,
        source  => 'puppet:///modules/sentry/install_sentry.sh',
        require => File['/opt/sentry'],
    }
    
    exec { 'install-sentry':
        command => '/bin/bash /opt/sentry/install.sh',
        user    => 'sentry',
        creates => '/opt/sentry/.installed',
        require => [File['/opt/sentry/install.sh'], Package['virtualenv']]
    }


}