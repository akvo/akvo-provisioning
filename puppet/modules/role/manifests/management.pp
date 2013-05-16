class role::management {

    notice("Including role: management")

    # let the DNS server know where we are
    bind::service_location { "management":
        ip => hiera('external_ip')
    }

    include puppetdb
    include bind
}