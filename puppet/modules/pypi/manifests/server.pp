class pypi::server {

    package { 'devpi':
        ensure   => 'installed',
        provider => 'pip'
    }

    user { 'devpi':
        ensure => present,
        home   => '/srv/devpi',
        shell  => '/bin/bash',
    }

    file { '/srv/devpi':
        ensure  => directory,
        owner   => 'devpi',
        mode    => 744,
        require => User['devpi']
    }

    supervisord::service { 'devpi':
        user    => 'devpi',
        command => "/usr/local/bin/devpi-server --datadir=/srv/devpi",
        require => File['/srv/devpi'],
    }

    sudo::service_control { 'devpi':
        user      => 'devpi',
    }

    $base_domain = hiera('base_domain')
    nginx::proxy { ["pypi.akvo-ops.org", "pypi.${base_domain}"]:
        proxy_url        => 'http://localhost:3141',
        ssl              => false,
    }

    named::service_location { 'pypi':
        ip => hiera('external_ip')
    }

}
