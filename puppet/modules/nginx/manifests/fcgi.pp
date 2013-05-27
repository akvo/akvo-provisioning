
define nginx::fcgi( $server_name,
                    $fcgi_address ) {

    file { "/etc/nginx/sites-enabled/$server_name":
        ensure  => present,
        content => template('nginx/fcgi.erb'),
        require => Package['nginx'],
        notify  => Service['nginx'],
    }

}