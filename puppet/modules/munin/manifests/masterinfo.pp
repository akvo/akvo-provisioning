
define munin::masterinfo( $ip ) {

    firewall { "200 munin master ${::ip}":
        action => accept,
        proto  => tcp,
        port   => 4949,
        source => $ip
    }

    $ip_regex = regsubst($ip, '\.', '\\.', 'G')

    # this exports a file line which will be collected by the
    file_line { $name:
        path   => "/etc/munin/munin-node.conf",
        line   => inline_template("allow ^<%= @ip_regex %>$"),
        notify => Service['munin-node'],
    }
}