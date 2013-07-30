
class htpasswd::fs {

    notice("Creating htpasswd dir")

    file { '/etc/htpasswd/':
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 755
    }

}