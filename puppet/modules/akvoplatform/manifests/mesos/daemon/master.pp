# == Class: akvoplatform::mesos::daemon::master
#
# This class configures mesos master daemon.
#
class akvoplatform::mesos::daemon::master inherits akvoplatform::params {

    class { '::mesos::master':
        cluster              => 'Akvo platform',
        zookeeper            => $zk_mesos_url,
        listen_address       => $mesos_daemon_listen_address,
        work_dir             => '/var/lib/mesos',
        options      => {
            quorum   => "${zk_quorum}",         # requires either array, hash or string
            hostname => $::fqdn,
            log_dir  => '/var/log/mesos'
        },
        require => Class['akvoplatform::mesos::zookeeper'],
    }

    # nginx proxy to mesos master on localhost
    $base_domain = hiera('base_domain')
    nginx::proxy { ["${hostname}.${public_domain}", "${hostname}.${base_domain}"]:
        proxy_url => "http://${mesos_daemon_listen_address}:${mesos_master_port}",
    }

    # open mesos master's console port
    firewall { '200 allow mesos master access':
        port   => $mesos_master_port,
        proto  => 'tcp',
        action => accept,
    }

    # ensure mesos-slave is not running on a master node
    service { 'mesos-slave':
        ensure  => 'stopped',
        enable  => false,
        require => Package['mesos']
    }

}
