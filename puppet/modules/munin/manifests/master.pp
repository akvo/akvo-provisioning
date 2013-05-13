class munin::master {

    include munin::common
  
    include nginx
    nginx::staticsite { 'munin-nginx':
        rootdir  => '/srv/munin/html',
        hostname => 'munin.${::base_domain}',
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

}
