# == Class: akvoplatform::consul
#
class akvoplatform::consul inherits akvoplatform::params {

    case $role {
        'master': {
            $config_hash = {
                'bootstrap_expect' => size($mesos_masters),
                'data_dir'         => '/opt/consul',
                'log_level'        => 'INFO',
                'datacenter'       => 'cloudvps',
                'node_name'        => "server-${::hostname}",
                'server'           => true,
                'ui_dir'           => '/opt/consul/ui',
                'retry_join'  => $mesos_masters
            }
            $tcpports = [8300, 8301, 8302, 8400, 8600] #8500
            $udpports = [8301, 8302, 8600]
        }
        'slave': {
            $config_hash = {
                'data_dir'    => '/opt/consul',
                'log_level'   => 'INFO',
                'datacenter'  => 'cloudvps',
                'node_name'   => "agent-${::hostname}",
                'retry_join'  => $mesos_masters
            }
            $tcpports = [8301, 8400, 8600] #8500
            $udpports = [8301, 8600]
        }
        default: { fail("Role must be 'master' or 'slave'.") }
    }

    # Need to specify the address that should be bound to for internal cluster communications.
    # By default, this is "0.0.0.0", meaning Consul will use the first available private IP
    # address (e.g. NAT interface on vagrant environments or docker virtual interface)
    class { '::consul':
        version       => $consul_version,
        config_hash   => $config_hash,
        extra_options => "-bind ${consul_backend}"
    }

    # nginx proxy to consul HTTP API listening on localhost
    nginx::proxy { ["consul.${public_domain}", "consul.${base_domain}"]:
        proxy_url       => "http://localhost:8500",
        htpasswd        => false,
        ssl             => true,
        ssl_key_source  => hiera('akvo_wildcard_key'),
        ssl_cert_source => hiera('akvo_wildcard_cert'),
        access_log      => "/var/log/nginx/consul-nginx-access.log",
        error_log       => "/var/log/nginx/consul-nginx-error.log",
    }

    # open TCP & UDP ports required by consul to work properly
    $mesos_masters.each |$master| {
        firewall { "200 allow consul tcp access client ${master}":
            port   => $tcpports,
            proto  => 'tcp',
            action => accept,
            source => $master
        }
        firewall { "200 allow consul udp access client ${master}":
            port   => $udpports,
            proto  => 'udp',
            action => accept,
            source => $master
        }
    }
    $mesos_slaves.each |$slave| {
        firewall { "200 allow consul tcp access client ${slave}":
            port   => $tcpports,
            proto  => 'tcp',
            action => accept,
            source => $slave
        }
        firewall { "200 allow consul udp access client ${slave}":
            port   => $udpports,
            proto  => 'udp',
            action => accept,
            source => $slave
        }
    }

}
