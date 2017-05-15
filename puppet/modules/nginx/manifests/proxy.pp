
define nginx::proxy( $server_name = undef,
                     $template = 'proxy',
                     $proxy_url,
                     $htpasswd = undef,
                     $ssl = false,
                     $ssl_key_source = undef,
                     $ssl_cert_source = undef,
                     $http_locations = undef,
                     $set_limits = undef,
                     $limit_zone_burst = undef,
                     $cache_expiration = undef,
                     $dh_params_source = undef,
                     $static_dirs = undef,
                     $extra_nginx_config = undef,
                     $extra_nginx_server_config = undef,
                     $extra_nginx_proxy_config = undef,
                     $access_log = undef,
                     $error_log = undef ) {

  include nginx

  if ( !$server_name ) {
      $server_name_val = $name
  } else {
      $server_name_val = $server_name
  }
  
  $filename = regsubst($server_name_val, '\*', '__star__')

  if ( !$access_log ) {
      $access_log_val = "/var/log/nginx/access-${filename}.log"
  } else {
      $access_log_val = $access_log
  }

  if ( !$error_log ) {
      $error_log_val = "/var/log/nginx/error-${filename}.log"
  } else {
      $error_log_val = $error_log
  }


  $htpasswd_file = "/etc/nginx/passwd/${filename}.htpasswd"
  $ssl_key = "/etc/nginx/certs/${filename}.key"
  $ssl_crt = "/etc/nginx/certs/${filename}.crt"
  $dh_params = "/etc/nginx/certs/dhparams.pem"


  file { "/etc/nginx/sites-enabled/${filename}":
      ensure  => present,
      content => template("nginx/${template}.erb"),
      require => Package['nginx'],
      notify  => Service['nginx'],
  }


  if $htpasswd {
      file { $htpasswd_file:
          ensure  => link,
          target  => '/etc/htpasswd/${htpasswd}',
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          require => Package['nginx'],
          notify  => Service['nginx'],
      }
  }


  if $ssl {
      file { $ssl_key:
          ensure  => present,
          content => $ssl_key_source,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          require => Package['nginx'],
          notify  => Service['nginx'],
      }

      file { $ssl_crt:
          ensure  => present,
          content => $ssl_cert_source,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          require => Package['nginx'],
          notify  => Service['nginx'],
      }

      ensure_resource('file', $dh_params, {
          ensure  => present,
          content => $dh_params_source,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          require => Package['nginx'],
          notify  => Service['nginx'],
      })
  }

}
