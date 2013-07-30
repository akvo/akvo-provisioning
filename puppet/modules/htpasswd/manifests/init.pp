
class htpasswd {

    file { '/etc/htpasswd/':
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 755
    }

}