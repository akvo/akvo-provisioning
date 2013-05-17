
define munin::nodeinfo() {

    file_line { $name:
        path   => '/etc/munin/munin.conf',
        line   => inline_template("[<%= fqdn %>]\n  address <%= fqdn %>"),
        tag    => 'munin-node-host',
    }
}