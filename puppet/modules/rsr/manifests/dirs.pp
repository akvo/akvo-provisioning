define rsr::dirs ( $approot, $username, $media_root ) {

    # make the directory that we'll use as the 'base'
    file { $approot:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => [ User[$username], Group[$username], File['/var/akvo/'] ],
    }

    $dirs = prefix([
        'logs',     # the log dir
        'versions'  # the directory for each version of the app
            ], "${approot}/")


    file { $dirs:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => [ User[$username], Group[$username], File[$approot] ],
    }

    # make sure the mediaroot exists
    file { $media_root:
        ensure  => directory,
        owner   => 'rsr',
        group   => 'rsr',
        mode    => '0755',
        require => Class['Akvoapp']
    }

    # link in our media which is kind of static
    rsr::staticcontent { [ 'akvo', 'core', 'widgets', 'ps_widgets', 'ps_widgets_old', 'partner_sites' ]:
        media_root => $media_root,
        approot    => $approot
    }

    # make sure that we back up the media!
    backups::dir { "rsr_media":
        path => "${media_root}/db"
    }

}