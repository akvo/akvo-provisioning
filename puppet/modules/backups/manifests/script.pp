define backups::script ($scriptname, $content) {


    file { "/backups/bin/${scriptname}":
        ensure  => present,
        mode    => 700,
        owner   => 'backup',
        group   => 'backup',
        content => $content
    }
}