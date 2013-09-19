define backups::script ($scriptname, $content) {


    file { "/backups/bin/${scriptname}":
        ensure  => present,
        mode    => '0700',
        owner   => 'backup',
        group   => 'backup',
        content => $content
    }
}