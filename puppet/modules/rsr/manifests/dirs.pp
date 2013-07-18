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
    file { "${media_root}/akvo":
        ensure  => 'link',
        target  => "${approot}/code/akvo/mediaroot/akvo",
        require => File[$media_root],
    }
    file { "${media_root}/core":
        ensure  => 'link',
        target  => "${approot}/code/akvo/mediaroot/core",
        require => File[$media_root],
    }
    file { "${media_root}/widgets":
        ensure  => 'link',
        target  => "${approot}/code/akvo/mediaroot/widgets",
        require => File[$media_root],
    }


}