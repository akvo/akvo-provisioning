# == Class: cartodb
#
# This class stores certificates and private keys into a specific path.
# It is needed to support SSL on our nginx containers:
#   https://github.com/jwilder/nginx-proxy#ssl-support
#
class cartodb {

  $path = hiera('cert_keys_path', '/etc/nginx/certs/')
  $hostnames = hiera_array('cartodb_hostnames')
  
  # add path and files extension
  $ssl_crts = suffix(prefix($hostnames, $path),'.crt')
  $ssl_keys = suffix(prefix($hostnames, $path),'.key')
  
  ensure_resource('file', $path, {
      ensure  => 'directory',
      owner   => 'www-data',
      mode    => '0700'
  })

  file { $ssl_keys:
        ensure  => present,
        content => hiera('akvo_wildcard_key'),
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        require => File[$path]
  }

  file { $ssl_crts:
        ensure  => present,
        content => hiera('akvo_wildcard_cert'),
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        require => File[$path]
  }

}
