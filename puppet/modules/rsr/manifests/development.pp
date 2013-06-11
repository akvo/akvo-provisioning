# this class represents a locally-developed copy of RSR, which is to
# be used when developing RSR on a local vagrant machine

class rsr::development {
    include rsr::common

    $database_host = $rsr::common::database_host
    $database_password = $rsr::common::database_password
    $logdir = $rsr::common::logdir

    # add custom configuration
    file { '/var/akvo/rsr/local_settings.conf':
        ensure   => present,
        owner    => 'rsr',
        group    => 'rsr',
        mode     => 444,
        content  => template('rsr/local.conf.erb'),
    }
}