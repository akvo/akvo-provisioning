# This module contains all of the useful packages which are required across all
# nodes and systems, including helpful tools like vim and tools for debugging and
# seeing system information.

class common {

    # The following packages are simply installed and the default configuration
    # is enough:

    $useful_packages = [
        'vim',
        'screen',
        'rsync',
        'iotop',
        'man',
        'manpages',
        'dnsutils',
        'telnet',
        'wget',
    ]

    package { $useful_packages:
        ensure => 'latest',
    }


    # These are all custom modules which will install the relevant packages as well as
    # configure them:

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