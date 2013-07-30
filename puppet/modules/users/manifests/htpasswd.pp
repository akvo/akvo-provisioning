
define users::htpasswd ( $role, $user, $password ) {

    ensure_resource('file', '/etc/htpasswd/', {
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 755
    })

    file_line { "htpasswd-${user}-${role}":
        path   => "/etc/htpasswd/${role}",
        line   => inline_template("${user}:${password}"),
    }

}