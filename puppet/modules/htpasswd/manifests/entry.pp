define htpasswd::entry($user, $password) {

    file_line { "htpasswd-${user}-${name}":
        path    => $name,
        line    => inline_template("${user}:${password}"),
        require => File[$name]
    }

}