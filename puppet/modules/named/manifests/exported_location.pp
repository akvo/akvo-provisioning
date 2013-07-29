
define named::exported_location ($zone, $subdomain, $ip) {

    notice("Exported: service ${subdomain} is at IP ${ip}")

    $zonefile = "/etc/bind/db.${zone}"

    file_line { "service_location_${name}":
        path   => $zonefile,
        line   => inline_template("<%= @subdomain %> IN A <%= @ip %>"),
        notify => Service['bind9']
    }

}