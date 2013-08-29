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
        'molly-guard',
    ]

    package { $useful_packages:
        ensure => 'latest',
    }


    # make sure pip is installed before anything tries to use it as a package provider
    package { 'python-pip':
        ensure => 'latest',
    }
    Package['python-pip'] -> Package <| provider == 'pip' and ensure != absent and ensure != purged |>


    named::service_location { "${::fqdn}.":
        # note the trailing full stop after fqdn - this is very important!
        # otherwise it will be considered a subdomain
        ip => hiera('internal_ip')
    }

    include backups
    include locales
    include users
    include sshd
    include common::repos
    include common::resolv
}

