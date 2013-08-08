define rsr::dirs ( $approot, $username, $media_root ) {

    # make the directory that we'll use as the 'base'
    file { $approot:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => 755,
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
        mode    => 755,
        require => [ User[$username], Group[$username], File[$approot] ],
    }

    # make sure the mediaroot exists
    file { $media_root:
        ensure  => directory,
        owner   => 'rsr',
        group   => 'rsr',
        mode    => 755,
        require => Class['Akvoapp']
    }


    # link in our media which is kind of static
    define rsr::staticcontent {
        file { "${media_root}/${name}":
            ensure  => 'link',
            target  => "${approot}/code/akvo/mediaroot/${name}",
            require => File[$media_root],
        }
    }

    rsr::staticcontent { [
        'akvo', 'core', 'widgets', 'ps_widgets', 'ps_widgets_old', 'partner_sites'
    ]: }

}