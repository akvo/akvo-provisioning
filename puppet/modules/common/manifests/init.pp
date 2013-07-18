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
        'curl',
    ]

    package { $useful_packages:
        ensure => 'latest',
    }

    @@named::service_location { "${::fqdn}.":
        # note the trailing full stop after fqdn - this is very important!
        # otherwise it will be considered a subdomain
        ip => hiera('internal_ip')
    }

    include locales
    include users
    include sshd
}

