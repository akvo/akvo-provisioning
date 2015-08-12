# == Class: akvoplatform::mesos::daemon::slave
#
# This class configures mesos slave daemon.
#
class akvoplatform::mesos::daemon::slave inherits akvoplatform::params {

    # mesos depends on virtual package 'java-runtime-headless'
    include javasupport

    class { '::mesos::slave':
        zookeeper      => $zk_mesos_url,
        listen_address => $mesos_daemon_listen_address,
        work_dir       => '/var/lib/mesos',
        resources      => {
            'ports' => "[${mesos_slave_docker_ports}]",
            #TODO http://mesos.apache.org/documentation/attributes-resources/
            #'mem' => '2048'
        },
        isolation      => 'cgroups/cpu,cgroups/mem',
        cgroups        => {
            'hierarchy' => '/sys/fs/cgroup',
            'root'  => 'mesos',
        },
        options => {
            containerizers                => 'docker,mesos',
            executor_registration_timeout => '5mins',
            hostname                      => $::fqdn,
            log_dir                       => '/var/log/mesos'
        },
        attributes => {
            environment => $::environment
        }
    }

    # nginx proxy to mesos slave on localhost
    $base_domain = hiera('base_domain')
    nginx::proxy { ["${hostname}.${public_domain}", "${hostname}.${base_domain}"]:
        proxy_url => "http://${mesos_daemon_listen_address}:${mesos_slave_port}",
    }

    # open mesos slave port
    firewall { '200 allow mesos slave access':
        port   => $mesos_slave_port,
        proto  => 'tcp',
        action => accept
    }

    # open mesos slave's port resources to all mesos masters
    $mesos_masters.each |$master| {
        firewall { "200 allow container ports client ${master}":
            port   => $mesos_slave_docker_ports,
            proto  => 'tcp',
            action => accept,
            source => $master
        }
    }

    # ensure mesos-master and zookeeper are not running on a slave node
    service { [ 'mesos-master', 'zookeeper' ]:
        ensure => stopped,
        enable => false,
        require => Package['mesos']
    }

}
