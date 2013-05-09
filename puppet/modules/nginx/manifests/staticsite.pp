
define nginx::staticsite( $hostname, $rootdir,
                          $password_protected = true ) {

  $htpasswd_file = "/etc/nginx/${server_name}.htpasswd"

  file { "/etc/nginx/sites-enabled/$hostname":
    ensure => present,
    content => template('nginx/staticsite.erb'),
    require => Package['nginx'],
    notify => Service['nginx'],
  }

  if $password_protected {
    file { $htpasswd_file:
      ensure  => present,
      source  => 'puppet:///modules/nginx/htpasswd',
      owner   => 'root',
      group   => 'root',
      mode    => 644,
      require => Package['nginx'],
      notify  => Service['nginx'],
    }
  }
  
}