
define nginx::configfile($content) {
    # This is a very simple resource which allows specifying a complete
    # nginx config file, rather than using the other convenience helpers.
    # This is useful for very complicated or different behaviours which are
    # not covered by the simple helpers
    include nginx

    $filename = $name

    file { "/etc/nginx/sites-enabled/${filename}":
        ensure  => present,
        content => $content,
        require => Package['nginx'],
        notify  => Service['nginx'],
    }
}