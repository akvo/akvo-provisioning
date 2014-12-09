
class xen {

    package { ['xen-hypervisor-amd64', 'xen-tools']:
        ensure => installed
    }

    sysctl { 'net.ipv4.ip_forward': value => '1' }
    sysctl { 'net.ipv4.conf.all.rp_filter': value => '1' }
    sysctl { 'net.ipv4.conf.default.proxy_arp': value => '1' }
    sysctl { 'net.ipv4.icmp_echo_ignore_broadcasts': value => '1' }
    sysctl { 'net.ipv6.conf.all.forwarding': value => '1' }

    augeas { "xen-config-toolstack":
        context => "/files/etc/default/xen",
        changes => [
            "set TOOLSTACK xm"
        ],
    }

    augeas { "xen-loopback-devices":
        context => "/files/etc/modules",
        changes => [
            "set loop max_loop=255"
        ],
    }

    # we are routing not bridging traffic:
    file_line { 'xend-config-network-route':
        path => '/etc/xen/xend-config.sxp',
        line => '(network-script network-route)'
    }

    file_line { 'xend-config-vif-route':
        path => '/etc/xen/xend-config.sxp',
        line => '(vif-script vif-route)'
    }

    file_line { 'xend-config-network-bridge':
        path  => '/etc/xen/xend-config.sxp',
        line  => '# (network-script network-bridge)'
        match => '^.*network-bridge.*$'
    }

    file_line { 'xend-config-vif-bridge':
        path  => '/etc/xen/xend-config.sxp',
        line  => '# (vif-script vif-bridge)'
        match => '^.*vif-bridge.*$'
    }

    # configure the defaults for xen tools to use when creating domU's
    $gateway_address = hiera('external_ip')
    $netmask = hiera('

}