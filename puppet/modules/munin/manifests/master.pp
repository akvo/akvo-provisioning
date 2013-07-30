class munin::master {

    include munin::common

    $base_domain = hiera('base_domain')
    $munin_domain = "munin.${base_domain}"

    include nginx
    nginx::staticsite { 'munin-nginx':
        rootdir            => '/srv/munin/html',
        hostname           => $munin_domain,
        #htpasswd          => 'ops',
    }

    file { '/srv/munin':
        ensure  => directory,
        owner   => 'munin',
        group   => 'munin',
        require => Package['munin'],
    }

    file { '/srv/munin/html':
        ensure  => directory,
        owner   => 'munin',
        group   => 'munin',
        require => [ File['/srv/munin'], Package['munin'] ],
    }

    file { '/etc/munin/munin.conf':
        ensure  => present,
        source  => 'puppet:///modules/munin/munin.conf',
        require => Package['munin'],
    }

    # Collect all exported munin-node file lines
    Munin::NodeInfo <<| |>>

    # let the DNS server know where we are
    named::service_location { "munin":
        ip => hiera('external_ip')
    }

    # let the munin nodes know where we are
    @@munin::masterinfo { "munin":
        ip => hiera('internal_ip')
    }

}
