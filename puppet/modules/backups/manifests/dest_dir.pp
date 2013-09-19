
define backups::dest_dir {

    file { "/backups/data/${name}":
        ensure  => directory,
        owner   => 'backup',
        group   => 'backup',
        mode    => 770,
        require => File['/backups']
    }

}