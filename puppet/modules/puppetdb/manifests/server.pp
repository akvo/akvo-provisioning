

class puppetdb::server {

    $base_domain = hiera('base_domain')
    $puppet_domain = "puppetdb.${base_domain}"

    # make sure the package is installed and up to date;
    # we have to ensure that the openjdk package is installed as there
    # seems to be an issue with the oracle java installer which the
    # puppetdb will install by default
    package { 'openjdk-7-jre-headless':
        ensure => 'latest'
    } ->
    package { 'puppetdb':
        ensure => 'latest' #'1.6.3-1puppetlabs1'  # version 2.0.0 refuses to start due to some obscure XML parsing issue
    }

    service { 'puppetdb':
        require    => Package['puppetdb'],
        ensure     => running,
        enable     => true,
        hasrestart => true,
    }


    # create an SSL proxy (puppet clients refuse to connect without SSL)
    $server_name = $puppet_domain
    $certfilename = "/etc/nginx/certs/${puppet_domain}.crt"
    $keyfilename = "/etc/nginx/certs/${puppet_domain}.key"
    $cacertfilename = "/etc/nginx/certs/puppetdb.ca.crt"

    file { $certfilename:
        ensure  => present,
        owner   => root,
        mode    => 0444,
        content => hiera('puppetdb_server_cert'),
        require => Package['nginx'],
        notify  => Service['nginx'],
    }
    file { $keyfilename:
        ensure  => present,
        owner   => root,
        mode    => 0444,
        content => hiera('puppetdb_server_key'),
        require => Package['nginx'],
        notify  => Service['nginx'],
    }
    file { $cacertfilename:
        ensure  => present,
        owner   => root,
        mode    => 0444,
        content => hiera('puppetdb_ca_cert'),
        require => Package['nginx'],
        notify  => Service['nginx'],
    }

    include nginx
    nginx::configfile { 'puppetdb':
        content => template('puppetdb/puppetdb-nginx.conf.erb')
    }

    # insert the config which runs the puppetdb service
    file { '/etc/puppetdb/conf.d/config.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => '0640',
        source  => 'puppet:///modules/puppetdb/config.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }

    file { '/etc/puppetdb/conf.d/jetty.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => '0640',
        source  => 'puppet:///modules/puppetdb/jetty.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }

    file { '/etc/puppetdb/conf.d/repl.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => '0640',
        source  => 'puppet:///modules/puppetdb/repl.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }

    file { '/etc/puppetdb/conf.d/database.ini':
        ensure  => present,
        owner   => 'puppetdb',
        group   => 'puppetdb',
        mode    => '0640',
        source  => 'puppet:///modules/puppetdb/database.ini',
        require => Package['puppetdb'],
        notify  => Service['puppetdb'],
    }

    # let the DNS server know where we are
    named::service_location { "puppetdb":
        ip => hiera('external_ip')
    }

    # this feels delicate, but will have to do for now: we also add this to
    # /etc/hosts to ensure that the puppetdb bootstrap process can find itself
    # without requiring the exported service name to work..
    file_line { "puppetdb_etc_hosts":
        path => '/etc/hosts',
        ensure => present,
        line => "127.0.0.1 puppetdb ${puppet_domain}"
    }
}