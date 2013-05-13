

class puppetdb {

    # make sure the package is installed and up to date
    package { 'puppetdb':
        ensure => 'latest',
    }

    service { 'puppetdb':
        require    => Package['puppetdb'],
        ensure     => running,
        enable     => true,
        hasrestart => true,
    }


    # we need nginx for proxying the puppetdb server
    include nginx

    # create an SSL proxy (puppet clients refuse to connect without SSL)
    nginx::proxy { 'testproxy':
        server_name        => "puppetdb.${::basedomain}",
        proxy_url          => 'http://localhost:8100',
        ssl                => true,
        password_protected => false,
    }

    # insert the config which runs the puppetdb service
    file { '/etc/puppetdb/conf.d/config.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => 640,
        source  => 'puppet:///modules/puppetdb/config.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }

    file { '/etc/puppetdb/conf.d/jetty.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => 640,
        source  => 'puppet:///modules/puppetdb/jetty.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }

    file { '/etc/puppetdb/conf.d/repl.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => 640,
        source  => 'puppet:///modules/puppetdb/repl.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }

    file { '/etc/puppetdb/conf.d/database.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => 640,
        source  => 'puppet:///modules/puppetdb/database.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }
}