class role::management {

    notice("Including role: management")

    # let the DNS server know where we are
    named::service_location { "management":
        ip => hiera('external_ip')
    }

    include puppetdb
    include named
}