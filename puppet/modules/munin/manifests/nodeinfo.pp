
define munin::nodeinfo( $target_fqdn ) {

    file_line { 'munin-node-${target_fqdn}':
        path   => '/etc/munin/munin.conf',
        line   => inline_template("[<%= target_fqdn %>]\n  address <%= target_fqdn %>"),
        tag    => 'munin-node-host',
    }
}