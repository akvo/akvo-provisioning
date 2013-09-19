

class puppetdb::server {

    $base_domain = hiera('base_domain')
    $puppet_domain = "puppetdb.${base_domain}"

    # make sure the package is installed and up to date
    package { 'puppetdb':
        ensure => 'latest',
    }

    service { 'puppetdb':
        require    => Package['puppetdb'],
        ensure     => running,
        enable     => true,
        hasrestart => true,
    }


    # we need nginx for proxying the puppetdb server
    include nginx

    # create an SSL proxy (puppet clients refuse to connect without SSL)
    nginx::proxy { 'puppetdb':
        server_name        => $puppet_domain,
        proxy_url          => 'http://localhost:8100',
        ssl                => true,
        htpasswd           => 'puppet',
    }

    # make sure we don't allow random connections!
#    htpasswd::user { 'puppet':
#        user     => 'puppet',
#        allow    => ['puppet'],
#        password => hiera('puppetdb_htpasswd')
#    }

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