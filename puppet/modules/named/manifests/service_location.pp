
define named::service_location(
    $subdomain = nil,
    $ip
){

    # get some environment specific vars
    $zone = hiera('base_domain')
    $zonefile = "/etc/bind/db.${zone}"

    if ($subdomain != nil) {
        $subdomainval = $subdomain
    } else {
        $subdomainval = $name
    }

    notice("Service ${subdomainval} is at IP ${ip}")

    # this exports a file line which will be collected by the
    file_line { "service_location_${name}":
        path   => $zonefile,
        line   => inline_template("<%= @subdomainval %> IN A <%= @ip %>"),
        notify => Service['bind9'],
    }

    # Export hostkeys from these hostnames.
    $base_domain = hiera('base_domain')
    @@sshkey { "${subdomainval}.${base_domain}":
        ensure       => present,
        host_aliases => [$subdomainval],
        type         => 'rsa',
        key          => $::sshrsakey,
    }
}
