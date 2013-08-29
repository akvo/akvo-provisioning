
define backups::dir {

    file { "/backups/${name}":
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        mode    => 770,
        require => File['/backups']
    }

}