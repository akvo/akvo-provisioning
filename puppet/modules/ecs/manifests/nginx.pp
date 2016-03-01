# == Class: ecs::nginx
#
# This class stores certificates and private keys into a specific path.
# It is needed to support SSL on our nginx containers:
#   https://github.com/jwilder/nginx-proxy#ssl-support
#
class ecs::nginx inherits ecs::params {

    ensure_resource('package', 'nginx', { ensure => present })

    # add path and files extension
    $ssl_crts = suffix(prefix($hostnames, $path),'.crt')
    $ssl_keys = suffix(prefix($hostnames, $path),'.key')
  
    ensure_resource('file', $path, {
        ensure  => 'directory',
        owner   => 'www-data',
        mode    => '0700',
        require => Package["nginx"]
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
