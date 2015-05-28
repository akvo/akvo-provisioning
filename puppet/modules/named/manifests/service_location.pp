
define named::service_location(
    $subdomain = nil,
    $ip
){

    if ($subdomain != nil) {
        $subdomainval = $subdomain
    } else {
        $subdomainval = $name
    }

    notice("Service ${subdomainval} is at IP ${ip}")

    # this exports a file line which will be collected by the
    @@named::exported_location { $name:
        subdomain => $subdomainval,
        ip        => $ip,
        tag       => $::environment
    }

    # Export hostkeys from these hostnames.
    # avoid to export hostkey if the hostname is the fqdn or '*',
    # it's already done in 'puppet/modules/sshd/manifests/init.pp'
    $base_domain = hiera('base_domain')
    if ('*' != $subdomainval) and ($::fqdn != "${subdomainval}.${base_domain}") {
        @@sshkey { "${subdomainval}.${base_domain}":
            ensure       => present,
            host_aliases => [$subdomainval],
            type         => 'rsa',
            key          => $::sshrsakey,
        }
    }
}
