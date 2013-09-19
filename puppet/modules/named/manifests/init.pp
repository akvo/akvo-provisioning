class named {

    # get some environment specific vars
    $zone = hiera('base_domain')
    $zonefile = "/etc/bind/db.${zone}"
    $dnsip = hiera("external_ip")

    # install bind and make sure puppet keeps the service alive
    package { 'bind9':
        ensure => installed,
    }
  
    service { 'bind9':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => File['/etc/bind/named.conf.local'],
    }

    # configure the list of zones we will manage
    file { '/etc/bind/named.conf.local':
        ensure  => present,
        owner   => 'bind',
        group   => 'bind',
        mode    => '0644',
        content => template('named/named.conf.local.erb'),
        require => Package['bind9'],
    }


    # configure our default management server zone file
    file { $zonefile:
        ensure  => present,
        content => template('named/envzone.erb'),
        owner   => 'bind',
        group   => 'bind',
        mode    => '0644',
        require => Package['bind9'],
        notify  => Service['bind9']
    }

    # Collect all exported dns record file lines
    Named::Exported_location <<| tag == $::environment |>>

}