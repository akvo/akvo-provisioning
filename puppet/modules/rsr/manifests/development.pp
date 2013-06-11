# this class represents a locally-developed copy of RSR, which is to
# be used when developing RSR on a local vagrant machine

class rsr::development {
    include rsr::common

    # for development, we need to install the requirements ourself since
    # no external deploy process will do that for us
    exec { "rsr_dev_install_requirements":
        command   => '/apps/rsr/venv/bin/pip install -r /apps/rsr/checkout/scripts/deployment/pip/requirements/2_rsr.txt',
        cwd       => '/apps/rsr/',
        user      => 'rsr',
        require   => [ Exec['make_venv_rsr'], Package['libmysqlclient-dev']], # currently requires mysql...
        logoutput => 'true',
        timeout   => 0, # this pip install step takes a looong time,
        notify    => Supervisord::Service['rsr'] # restart once the required libs and binaries are in place
    }

    # run the database setup and synchronisation
    rsr::djangocommand { "syncdb":
        command  => 'syncdb --noinput'
    }
    rsr::djangocommand { "migrate":
        require => Rsr::Djangocommand['syncdb'],
    }


    $database_host = $rsr::common::database_host
    $database_password = $rsr::common::database_password
    $logdir = $rsr::common::logdir

    # add custom configuration
    file { '/apps/rsr/checkout/akvo/settings/60_puppet.conf':
        ensure   => present,
        owner    => 'rsr',
        group    => 'rsr',
        mode     => 444,
        content  => template('rsr/local.conf.erb'),
    }
}