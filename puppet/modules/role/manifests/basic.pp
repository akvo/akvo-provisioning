class role::basic {
    notice("Including role: basic")

    include common

    include sudo
    include puppetcontrol
    include munin::node

    # TODO: remove this once DNS is working!
    include common::hosts

    # include sshd
    # include users
    # include dotfiles
    # include supervisord

}