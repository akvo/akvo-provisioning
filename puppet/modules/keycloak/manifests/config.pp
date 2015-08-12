class keycloak::config {

    $qport = $keycloak::port
    $db_name = $keycloak::db_name
    $db_host = $keycloak::db_host
    $db_username = $keycloak::db_username
    $db_password = $keycloak::db_password

    $base_domain = hiera('base_domain')
    $appdir = $keycloak::appdir

    sudo::admin_user { 'stellan': }

    #Drop in a new config file that uses psql db and nginx proxy
    file { "${appdir}/standalone/configuration/standalone.xml":
        ensure  => present,
        owner   => 'keycloak',
        group   => 'keycloak',
        mode    => '0644',
        content  => template('keycloak/standalone.xml.erb')
    }

    named::service_location { 'login':
        ip => hiera('external_ip')
    }

    nginx::proxy { "login.${base_domain}":
        proxy_url                 => "http://127.0.0.1:${qport}",
        extra_nginx_proxy_config  => template('keycloak/nginx-extra-proxy.conf.erb'),
        ssl                       => true,
        ssl_key_source            => hiera('akvo_wildcard_key'),
        ssl_cert_source           => hiera('akvo_wildcard_cert'),
        htpasswd                  => false
    }

}
