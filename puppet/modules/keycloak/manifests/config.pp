# Configure Keycloak module
class keycloak::config {

  $appdir          = $keycloak::appdir
  $approot         = $keycloak::approot
  $base_domain     = $keycloak::base_domain
  $config_file     = $keycloak::config_file
  $ip              = $keycloak::ip
  $port            = $keycloak::port
  $ssl_cert_source = $keycloak::ssl_cert_source
  $ssl_key_source  = $keycloak::ssl_key_source

  sudo::admin_user { 'stellan': }

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

  # Configure Keycloak
  exec { 'saxon-xslt':
    command => "saxon-xslt -o ${config_file} ${config_file} \
                ${approot}/configure.xsl",
    path    => '/usr/bin'
  }

}
