
define nginx::proxy( $server_name = undef,
                     $proxy_url,
                     $htpasswd = undef,
                     $ssl = true,
                     $static_dirs = undef ) {

  include nginx

  if ( !$server_name ) {
      $server_name_val = $name
  } else {
      $server_name_val = $server_name
  }

  $htpasswd_file = "/etc/nginx/passwd/${server_name_val}.htpasswd"
  $ssl_key = "/etc/nginx/certs/${server_name_val}.key"
  $ssl_crt = "/etc/nginx/certs/${server_name_val}.crt"


  file { "/etc/nginx/sites-enabled/${server_name_val}":
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
          mode    => 444,
          require => Package['nginx'],
          notify  => Service['nginx'],
      }
  }


  if $ssl {
      file { $ssl_key:
          ensure  => present,
          source  => 'puppet:///modules/nginx/akvo-self.key',
          owner   => 'root',
          group   => 'root',
          mode    => 444,
          require => Package['nginx'],
          notify  => Service['nginx'],
      }

      file { $ssl_crt:
          ensure  => present,
          source  => 'puppet:///modules/nginx/akvo-self.crt',
          owner   => 'root',
          group   => 'root',
          mode    => 444,
          require => Package['nginx'],
          notify  => Service['nginx'],
      }
  }

}