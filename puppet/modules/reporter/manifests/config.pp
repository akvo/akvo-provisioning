
class reporter::config {

    $qport = $reporter::port
    $db_name = $reporter::db_name
    $db_host = $reporter::db_host
    $db_username = $reporter::db_username
    $db_password = $reporter::db_password

    $base_domain = hiera('base_domain')
    $url_prefix = "http://reporter.${base_domain}"

    $approot = $reporter::approot

    sudo::admin_user { 'stellan': }
    sudo::admin_user { 'gabriel': }

    file { "${approot}/populate_psql_db.sh":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0755',
        content  => template('reporter/populate_psql_db.sh.erb'),
        require => File[$approot]
    }


    exec { "${approot}/populate_psql_db.sh":
        user    => 'root',
        cwd     => "${approot}",
        creates => "${approot}/.db_created",
        require => File["${approot}/populate_psql_db.sh"]
    }


    named::service_location { 'reporting':
        ip => hiera('external_ip')
    }

    nginx::proxy { "reporting.${base_domain}":
        proxy_url                 => "http://localhost:${qport}",
        extra_nginx_proxy_config  => template('reporter/nginx-extra-proxy.conf.erb'),
        ssl                       => true,
        ssl_key_source            => hiera('akvo_wildcard_key'),
        ssl_cert_source           => hiera('akvo_wildcard_cert'),
        htpasswd                  => false
    }

}
