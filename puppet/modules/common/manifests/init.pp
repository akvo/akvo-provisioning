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

    include backups
    include locales
    include users
    include sshd
    include common::repos
    include common::resolv
    include fw

    if (!hiera('lite', false)) {
        # We have a "lite" mode primarily for vagrant boxes, to avoid installing
        # a bunch of services that we don't need, typically to do with monitoring.
        # This helps lower the memory/CPU footprint which helps when developing locally.
        include common::collectd
        include systemstats
        include mta
        include statsd

        $extra_packages = [
            'update-notifier-common',
            'rkhunter',
        ]
        package { $extra_packages:
            ensure => 'latest',
        }

        $rkrun = "/usr/bin/rkhunter --update --rwo --nocolors --skip-keypress --check"
        $rkmail = "/usr/bin/mail -s '[`hostname -f`] RKHunter run for `date +\"%d-%m-%Y\"' devops-reports@akvo.org"
        cron { 'rkhunter':
            command => "${rkrun} | ${rkmail}",
            user    => root,
            hour    => 2,
            minute  => 0
        }
    }

}

