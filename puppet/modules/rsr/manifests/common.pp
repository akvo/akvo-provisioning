# This class pulls together the parts which are required by both installed
# and development versions of RSR

class rsr::common {

    # some shared config
    $approot = '/var/akvo/rsr'
    $database_password = 'lake'
    $base_domain = hiera('base_domain')
    $database_host = "mysql.${base_domain}"
    $media_root = "${approot}/mediaroot/"
    $logdir = "${approot}/logs/"
    $port = 8000


    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    require akvoapp

    # include our RSR-specific akvo info
    akvoapp::app { 'rsr':
        require => [
            Class['akvoapp::pythonsupport::mysql'],
            Class['akvoapp::pythonsupport::pil'],
            Class['akvoapp::pythonsupport::lxml'],
        ]
    }
    akvoapp::djangoapp { 'rsr': }


    # make sure the mediaroot exists
    file { $media_root:
        ensure  => directory,
        owner   => 'rsr',
        group   => 'rsr',
        mode    => 755,
        require => Akvoapp::App['rsr']
    }

    # add custom configuration
    file { "${approot}/local_settings.conf':
        ensure   => present,
        owner    => 'rsr',
        group    => 'rsr',
        mode     => 444,
        content  => template('rsr/local.conf.erb'),
    }


    # install all of the support packages
    include akvoapp::pythonsupport::mysql
    include akvoapp::pythonsupport::pil
    include akvoapp::pythonsupport::lxml


    # create an RSR database on the database server
    @@database::my_sql::db { 'rsr':
        password => $database_password
    }


    # we want a service address
    # TODO: this needs to consider partnersite stuff
    @@named::service_location { "rsr":
        ip => hiera('external_ip')
    }


    # nginx sits in front of RSR
    nginx::proxy { 'rsr':
        server_name        => "rsr.${base_domain}",
        proxy_url          => "http://localhost:${port}",
        password_protected => false,
        static_dirs        => {
            "/rsr/media/admin/" => "${approot}/venv/lib/python2.7/site-packages/django/contrib/admin/static/admin/",
            "/rsr/media/"       => $media_root,
        }
    }


    # configure a service so we can start and restart RSR
    include supervisord
    supervisord::service { "rsr":
        user      => 'rsr',
        command   => "${approot}/venv/bin/gunicorn akvo.wsgi --pythonpath ${approot}/git/current/ --pid ${approot}/rsr.pid --bind 127.0.0.1:${port}",
        directory => $approot,
    }
    # we want the rsr user to be able to restart the process
    sudo::service_control { "rsr":
        user         => 'rsr',
    }

}