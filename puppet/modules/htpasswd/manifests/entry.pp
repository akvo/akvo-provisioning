define htpasswd::entry($user, $password) {

    $path = regsubst($name, '^.*::', '')

    notice("Allowing user ${user} access using file ${path}")

    file_line { "htpasswd-${user}-${path}":
        path    => $path,
        line    => inline_template("${user}:${password}"),
        require => File[$path]
    }

}