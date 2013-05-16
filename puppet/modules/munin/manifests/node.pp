class munin::node {

    package { 'munin-node':
        ensure => installed,
    }

    $management_ip_regex = regsubst($management_server_ip, '\.', '\\.', 'G')

    file { '/etc/munin/munin-node.conf':
        ensure  => present,
        content => template('munin/munin-node.conf.erb'),
        require => Package['munin-node'],
    }

    service { 'munin-node':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => File['/etc/munin/munin-node.conf'],
    }

    @@munin::nodeinfo { "munin_node-host-${::fqdn}": }

    # figure out where the masters are so we can allow them to connect
    Munin::MasterInfo <<| |>>

}
