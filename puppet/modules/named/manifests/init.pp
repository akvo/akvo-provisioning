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

    file { '/etc/bind/named.conf':
        ensure  => present,
        owner   => 'bind',
        group   => 'bind',
        mode    => 440,
        require => Package['bind9'],
        notify  => Service['bind9'],
        source  => 'puppet:///modules/named/named.conf',
    }

    # collectd stats
    common::collectd_plugin { 'bind':
        args => {
            url => 'http://localhost:8053'
        }
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

    firewall { '100 named':
        port   => 53,
        action => accept,
        proto  => 'udp'
    }
}