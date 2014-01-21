
define nginx::staticsite( $hostname, $rootdir,
                          $htpasswd = undef,
                          $ssl = false,
                          $ssl_key_source = undef,
                          $ssl_cert_source = undef ) {

    include nginx

    $htpasswd_file = "/etc/nginx/${hostname}.htpasswd"
    $ssl_key = "/etc/nginx/certs/${hostname}.key"
    $ssl_crt = "/etc/nginx/certs/${hostname}.crt"

    file { "/etc/nginx/sites-enabled/${hostname}":
        ensure  => present,
        content => template('nginx/staticsite.erb'),
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