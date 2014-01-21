
define nginx::fcgi( $server_name,
                    $fcgi_address,
                    $htpasswd = undef,
                    $ssl = false,
                    $ssl_key_source = undef,
                    $ssl_cert_source = undef) {

    include nginx

    $htpasswd_file = "/etc/nginx/${server_name}.htpasswd"
    $ssl_key = "/etc/nginx/certs/${server_name}.key"
    $ssl_crt = "/etc/nginx/certs/${server_name}.crt"

    file { "/etc/nginx/sites-enabled/$server_name":
        ensure  => present,
        content => template('nginx/fcgi.erb'),
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