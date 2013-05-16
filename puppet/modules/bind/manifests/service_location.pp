
define bind::service_location(
    $subdomain = nil,
    $ip
){

    # get some environment specific vars
    $zone = hiera('base_domain')
    $zonefile = "/srv/bind/db.${zone}"

    if ($subdomain != nil) {
        $subdomainval = $subdomain
    } else {
        $subdomainval = $name
    }

    # this exports a file line which will be collected by the
    file_line { "service_location_${name}":
        path   => $zonefile,
        line   => inline_template("<%= subdomainval %> IN A <%= ip %>"),
        notify => Service['bind9'],
    }

}