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
    }
}