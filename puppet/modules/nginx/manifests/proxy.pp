
define nginx::proxy( $server_name,
                     $proxy_url,
                     $password_protected = true,
                     $ssl = true ) {

  $htpasswd_file = "/etc/nginx/passwd/${server_name}.htpasswd"
  $ssl_key = "/etc/nginx/certs/${server_name}.key"
  $ssl_crt = "/etc/nginx/certs/${server_name}.crt"


  file { "/etc/nginx/sites-enabled/$server_name":
      ensure  => present,
      content => template('nginx/proxy.erb'),
      require => Package['nginx'],
      notify  => Service['nginx'],
  }


  if $password_protected {
      file { $htpasswd_file:
          ensure  => present,
          source  => 'puppet:///modules/nginx/htpasswd',
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