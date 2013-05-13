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

    @@file_line { 'munin_node-host':
        path   => '/etc/munin/munin.conf',
        line   => inline_template("[<%= fqdn %>]\n  address <%= fqdn %>"),
        tag    => 'munin-node-host',
    }

}
