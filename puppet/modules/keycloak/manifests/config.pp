
class keycloak::config {

    $qport = $keycloak::port
    $db_name = $keycloak::db_name
    $db_host = $keycloak::db_host
    $db_username = $keycloak::db_username
    $db_password = $keycloak::db_password

    $base_domain = hiera('base_domain')
#    $url_prefix = "http://keycloak.${base_domain}"

    $approot = $keycloak::approot

    sudo::admin_user { 'stellan': }

    file { "${approot}/keycloak-1.3.1.Final/standalone/configuration/standalone.xml":
        ensure  => present,
        owner   => 'keycloak',
        group   => 'keycloak',
        mode    => '0755',
        source  => 'puppet:///modules/keycloak/standalone.xml'
    }


#    exec { "${approot}/populate_psql_db.sh":
#        user    => 'root',
#        cwd     => "${approot}",
#        creates => "${approot}/.db_created",
#        require => File["${approot}/populate_psql_db.sh"]
#    }


    named::service_location { 'login':
        ip => hiera('external_ip')
    }

    nginx::proxy { "login.${base_domain}":
        proxy_url                 => "http://127.0.0.1:${qport}",
#        extra_nginx_proxy_config  => template('keycloak/nginx-extra-proxy.conf.erb'),
        ssl                       => true,
        ssl_key_source            => hiera('akvo_wildcard_key'),
        ssl_cert_source           => hiera('akvo_wildcard_cert'),
        htpasswd                  => false
    }

}
