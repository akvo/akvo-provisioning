class role::basic {
    notice("Including role: basic")

    include common

    include sudo
    include puppetcontrol
    include munin::node

    if ( $::machine_type == 'vagrant' ) {
        # we can't use DNS delegation for local environments,
        # so we'll hardcode the puppetdb server
        $domain = hiera('base_domain')

        file_line { "hosts_${name}":
            path   => '/etc/hosts',
            line   => inline_template("192.168.50.101 puppetdb.<%= @domain %>"),
        }
    }

    # include sshd
    # include users
    # include dotfiles
    # include supervisord

}