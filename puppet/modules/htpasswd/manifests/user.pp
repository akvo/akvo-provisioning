
define htpasswd::user ($user, $allow, $password) {

    include htpasswd::fs

    $allow_files = prefix($allow, "/etc/htpasswd/")

    ensure_resource('file', $allow_files, {
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 444,
        require => File['/etc/htpasswd']
    })

    htpasswd::entry { $allow_files:
        user     => $user,
        password => $password,
    }

}