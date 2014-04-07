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
        'htop',
        'man',
        'manpages',
        'dnsutils',
        'telnet',
        'wget',
        'curl',
        'molly-guard',
        'finger',
        'members',
        'zip',
        'zsh'
    ]

    package { $useful_packages:
        ensure => 'latest',
    }


    # make sure pip is installed before anything tries to use it as a package provider
    package { 'python-pip':
        ensure => 'latest',
    }
    Package['python-pip'] -> Package <| provider == 'pip' |>


    named::service_location { "${::fqdn}.":
        # note the trailing full stop after fqdn - this is very important!
        # otherwise it will be considered a subdomain
        ip => hiera('external_ip')
    }

    include locales
    include users
    include sshd
    include common::repos
    include common::resolv

    # the "lite" config flag turns off some monitoring processes; this helps reduce the load on
    # machines which don't need it, primarily vagrant development machines and temporary test VMs
    if ( !hiera('lite', false) ) {
        package { [
            'rkhunter',
            'update-notifier-common'
        ] : ensure => latest
        }

        $rkrun = "/usr/bin/rkhunter --update --rwo --nocolors --skip-keypress --check"
        $rkmail = "/usr/bin/mail -s '[`hostname -f`] RKHunter run for `date +\"%d-%m-%Y\"' devops-reports@akvo.org"
        cron { 'rkhunter':
            command => "${rkrun} | ${rkmail}",
            user    => root,
            hour    => 2,
            minute  => 0
        }

        include backups
        include common::collectd
        include systemstats
        include mta
        include statsd
    }

}

