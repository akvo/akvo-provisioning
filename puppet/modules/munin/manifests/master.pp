class munin::master {

    include munin::common

    $base_domain = hiera('base_domain')
    $munin_domain = "munin.${base_domain}"

    include nginx
    nginx::staticsite { 'munin-nginx':
        rootdir  => '/srv/munin/html',
        hostname => $munin_domain,
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
    File_Line <<| tag == "munin-node-host" |>>

}
