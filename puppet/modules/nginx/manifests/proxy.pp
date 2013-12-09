
define nginx::proxy( $server_name = undef,
                     $proxy_url,
                     $htpasswd = undef,
                     $ssl = false,
                     $ssl_key_source = undef,
                     $ssl_cert_source = undef,
                     $static_dirs = undef,
                     $extra_nginx_config = undef ) {

  include nginx

  if ( !$server_name ) {
      $server_name_val = $name
  } else {
      $server_name_val = $server_name
  }

  $filename = regsubst($server_name_val, '\*', '__star__')

  $htpasswd_file = "/etc/nginx/passwd/${filename}.htpasswd"
  $ssl_key = "/etc/nginx/certs/${filename}.key"
  $ssl_crt = "/etc/nginx/certs/${filename}.crt"


  file { "/etc/nginx/sites-enabled/${filename}":
      ensure  => present,
      content => template('nginx/proxy.erb'),
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
          source  => $ssl_key_source,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          require => Package['nginx'],
          notify  => Service['nginx'],
      }

      file { $ssl_crt:
          ensure  => present,
          source  => $ssl_cert_source,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          require => Package['nginx'],
          notify  => Service['nginx'],
      }
  }

}