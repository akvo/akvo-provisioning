class munin::node {

    package { 'munin-node':
        ensure => installed,
    }

    file { '/etc/munin/munin-node.conf':
        ensure  => present,
        source  => 'puppet:///modules/munin/munin-node.conf',
        require => Package['munin-node'],
    }

    service { 'munin-node':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => File['/etc/munin/munin-node.conf'],
    }

}
