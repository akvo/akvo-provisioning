
class rsr::install {

    # we need the config
    include rsr::params

    $approot = $rsr::params::approot
    $username = $rsr::params::username
    $media_root = $rsr::params::media_root
    $static_root = $rsr::params::static_root

    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    akvoapp { $username:
        deploy_key => hiera('rsr-deploy_public_key')
    }

    # install all of the support packages
    include pythonsupport::mysql
    include pythonsupport::pil
    include pythonsupport::lxml
    include pythonsupport::standard

    include memcached
    include nodejs

    package { ['less', 'yuglify']:
        ensure   => 'installed',
        provider => 'npm'
    }

    file { "${approot}/versions":
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => [ User[$username], Group[$username], File[$approot] ],
    }

    # make sure the mediaroot and staticroot exists
    file { [$media_root, $static_root]:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => File[$approot]
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


    # support for copying data between machines
    if hiera('rsr_data_source') {
        class { 'rsr::datasource': }
    } else {
        class { 'rsr::leech': }
    }


    # make sure that we back up the media!
    backups::dir { "rsr_media":
        path => "${media_root}/db"
    }

}