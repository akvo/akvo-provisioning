
define htpasswd::user ($user, $role, $password) {

    include htpasswd::fs

    ensure_resource('file', "/etc/htpasswd/${role}", {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 444,
        require => File['/etc/htpasswd']
    })

    file_line { "htpasswd-${user}-${role}":
        path    => "/etc/htpasswd/${role}",
        line    => inline_template("${user}:${password}"),
        require => File['/etc/htpasswd/']
    }

}