class opendata::config inherits opendata::params {

    # remove default ckan vhost
    file { 'ckan-nginx-disable':
        path => '/etc/nginx/sites-enabled/ckan',
        ensure => absent
    }

    # we want a service address
    named::service_location { 'opendata':
        ip => hiera('external_ip')
    }

    # SSL configuration
    $base_domain = hiera('base_domain')
    nginx::proxy { $hostname:
        proxy_url                 => "http://${wsgi_host}:${wsgi_port}",
        htpasswd                  => false,
        ssl                       => true,
        ssl_key_source            => hiera('akvo_wildcard_key'),
        ssl_cert_source           => hiera('akvo_wildcard_cert'),
        extra_nginx_config        => template('opendata/nginx-extra.conf.erb'),
        extra_nginx_server_config => template('opendata/nginx-extra-server.conf.erb'),
        extra_nginx_proxy_config  => template('opendata/nginx-extra-proxy.conf.erb')
    }

    # let the build server know how to log in to us
    @@teamcity::deploykey { "${username}-${::environment}":
        service     => 'opendata',
        environment => $::environment,
        key         => hiera('opendata-deploy_private_key'),
    }

    # we want the 'backup' user to be able to execute 'ckan' in order to perform backups
    sudo::allow_command { "opendata-backup-ckan":
        user    => 'backup',
        command => '/usr/bin/ckan'
    }

    sudo::admin_user { 'lynn': }

    # no password - we need that setting for the deployment scripts
    sudo::admin_user { $username:
        nopassword => true
    }

}
