# Configure Keycloak module
class keycloak::config {

  $appdir          = $keycloak::appdir
  $base_domain     = $keycloak::base_domain
  $ip              = $keycloak::ip
  $port            = $keycloak::port
  $ssl_cert_source = $keycloak::ssl_cert_source
  $ssl_key_source  = $keycloak::ssl_key_source
  
  sudo::admin_user { 'stellan': }

  # Drop in a new config file that uses psql db and nginx proxy
  file { "${appdir}/standalone/configuration/standalone.xml":
    ensure  => present,
    owner   => 'keycloak',
    group   => 'keycloak',
    mode    => '0644',
    content => template('keycloak/standalone.xml.erb')
  }

  named::service_location { 'login':
    ip => $ip
  }

  nginx::proxy { "login.${base_domain}":
    proxy_url                => "http://127.0.0.1:${port}",
    extra_nginx_proxy_config => template('keycloak/nginx-extra-proxy.conf.erb'),
    ssl                      => true,
    ssl_key_source           => $ssl_key_source,
    ssl_cert_source          => $ssl_cert_source,
    htpasswd                 => false
  }

}
