
define htpasswd::user ($user, $role, $password) {

    include htpasswd::fs

    $rolefile = "/etc/htpasswd/${role}"

    ensure_resource('file', $rolefile, {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 444,
        require => File['/etc/htpasswd']
    })

    file_line { "htpasswd-${user}-${role}":
        path    => $rolefile,
        line    => inline_template("${user}:${password}"),
        require => File[$rolefile]
    }

}