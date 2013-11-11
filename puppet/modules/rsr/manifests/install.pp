
class rsr::install {

    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    require akvoapp


    # we need the config
    include rsr::params
    include rsr::user


    # install all of the support packages
    include pythonsupport::mysql
    include pythonsupport::pil
    include pythonsupport::lxml
    include pythonsupport::standard
    include memcached


    # create all of the directories
    $approot = $rsr::params::approot
    $username = $rsr::params::username
    $media_root = $rsr::params::media_root

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
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => Class['Akvoapp']
    }


    # include the script for downloading and creating an app
    file { "${approot}/make_app.sh":
        ensure  => present,
        content => template('rsr/make_app.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for switching the app
    file { "${approot}/make_current.sh":
        ensure  => present,
        content => template('rsr/make_current.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for switching the app
    file { "${approot}/update_current.sh":
        ensure  => present,
        content => template('rsr/update_current.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for cleaning up old versions
    file { "${approot}/cleanup_old.sh":
        ensure  => present,
        content => template('rsr/cleanup_old.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for managing the django application
    file { "${approot}/manage.sh":
        ensure  => present,
        content => template('rsr/manage.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for cleaning up stale invoices
    file { "${approot}/cleanup_stale_invoices.sh":
        ensure  => present,
        content => template('rsr/cleanup_stale_invoices.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    cron { 'cleanup_stale_invoices':
      command => "bash -c ${approot}/cleanup_stale_invoices.sh",
      user    => 'rsr',
      minute  => '*/15'
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