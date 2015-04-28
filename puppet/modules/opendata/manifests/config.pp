class opendata::config {

    # remove default ckan vhost
    file { 'ckan-nginx-disable':
        path => '/etc/nginx/sites-enabled/ckan',
        ensure => absent
    }

    # SSL configuration
    $base_domain = hiera('base_domain')
    nginx::proxy { $opendata::params::hostnames:
        proxy_url                 => "http://${opendata::params::wsgi_host}:${opendata::params::wsgi_port}",
        htpasswd                  => false,
        ssl                       => true,
        ssl_key_source            => hiera('akvo_wildcard_key'),
        ssl_cert_source           => hiera('akvo_wildcard_cert'),
        extra_nginx_config        => template('opendata/nginx-extra.conf.erb'),
        extra_nginx_server_config => template('opendata/nginx-extra-server.conf.erb'),
        extra_nginx_proxy_config  => template('opendata/nginx-extra-proxy.conf.erb')
    }

    # we want the 'backup' user to be able to execute 'ckan' in order to perform backups
    sudo::allow_command { "opendata-backup-ckan":
        user    => 'backup',
        command => '/usr/bin/ckan'
    }

}
