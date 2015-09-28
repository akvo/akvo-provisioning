# == Class: akvoplatform::mesos::zookeeper
#
# Installs and configures zookeeper.
#
class akvoplatform::mesos::zookeeper inherits akvoplatform::params {

    include javasupport

    class { '::zookeeper':
        client_ip => $mesos_daemon_listen_address,
        id        => $akvoplatform::params::zk_config::myid,
        servers   => $mesos_masters,
        require   => Class['Javasupport']
    }

    $mesos_masters.each |$master| {
        firewall { "200 allow zookeeper client ${master}":
            port   => $zookeeper_server_ports,
            proto  => 'tcp',
            action => accept,
            source => $master
        }
    }

    $mesos_slaves.each |$slave| {
        firewall { "200 allow zookeeper client ${slave}":
            port   => $zookeeper_client_port,
            proto  => 'tcp',
            action => accept,
            source => $slave
        }
    }

}
