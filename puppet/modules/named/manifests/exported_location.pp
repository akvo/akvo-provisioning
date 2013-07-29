
define named::exported_location ($subdomain, $ip) {

    notice("Exported: service ${subdomain} is at IP ${ip}")

    file_line { "service_location_${name}":
        path   => $zonefile,
        line   => inline_template("<%= @subdomain %> IN A <%= @ip %>"),
        notify => Service['bind9']
    }

}