# This class pulls together the parts which are required by both installed
# and development versions of RSR

class rsr::common {

    # some shared config
    $database_password = 'lake'
    $base_domain = hiera('base_domain')
    $database_host = "psql.${base_domain}"
    $media_root = "/apps/rsr/checkout/akvo/mediaroot/"
    $logdir = "/var/log/akvo/rsr/"
    $port = 8000


    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    require akvoapp


    # include our RSR-specific akvo info
    akvoapp::app { 'rsr': } # no parameters yet
    akvoapp::djangoapp { 'rsr': }


    # install all of the support packages
    # currently, use of mysql is hardcoded in the requirements file
    # this should be removed
    include akvoapp::pythonsupport::mysql
    # we'll actually be using postgres
    include akvoapp::pythonsupport::psql
    include akvoapp::pythonsupport::pil
    include akvoapp::pythonsupport::lxml


    # create an RSR database on the database server
    @@database::psql::db { 'rsr':
        password => $database_password
    }


    # add custom configuration
    file { '/apps/rsr/checkout/akvo/settings/60_puppet.conf':
        ensure   => present,
        owner    => 'rsr',
        group    => 'rsr',
        mode     => 444,
        content  => template('rsr/local.conf.erb'),
    }


    # we want a service address
    # TODO: this needs to consider partnersite stuff
    @@named::service_location { "rsr":
        ip => hiera('external_ip')
    }


    # nginx sits in front of RSR
    nginx::fcgi { 'rsr':
        server_name  => "rsr.${base_domain}",
        fcgi_address => "localhost:${port}",
    }


    # configure a service so we can start and restart RSR
    include supervisord
    supervisord::service { "rsr":
        user      => 'rsr',
        # TODO: temporary, we allow anything to connect, until the nginx proxy is in place
        command   => "/apps/rsr/venv/bin/python /apps/rsr/checkout/akvo/manage.py runserver 0.0.0.0:${port}",
        directory => "/apps/rsr/",
    }
    # we want the rsr user to be able to restart the process
    sudo::service_control { "rsr":
        user         => 'rsr',
    }

}