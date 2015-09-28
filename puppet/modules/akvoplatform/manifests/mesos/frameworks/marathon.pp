# == Class: akvoplatform::mesos::frameworks::marathon
#
# This class installs and configures the marathon framework for mesos.
#
# TODO keystore & basic authentication - https://mesosphere.github.io/marathon/docs/ssl-basic-access-authentication.html
class akvoplatform::mesos::frameworks::marathon inherits akvoplatform::params {

    class { '::marathon':
        install_java => false,
        bin_path     => '/usr/bin',
        master       => $zk_mesos_url,          # the zookeeper url of mesos masters
        zk           => $zk_marathon_url        # the zookeeper url for storing marathon's state
    }

    # nginx proxy to marathon UI
    nginx::proxy { ["marathon.${public_domain}", "marathon.${base_domain}"]:
        proxy_url       => "http://localhost:${marathon_port}",
        htpasswd        => false,
        ssl             => true,
        ssl_key_source  => hiera('akvo_wildcard_key'),
        ssl_cert_source => hiera('akvo_wildcard_cert'),
        access_log      => "/var/log/nginx/marathon-nginx-access.log",
        error_log       => "/var/log/nginx/marathon-nginx-error.log",
    }

    # open marathon UI port
    $mesos_masters.each |$master| {
        firewall { "200 allow marathon client ${master}":
            port   => $marathon_port,
            proto  => 'tcp',
            action => accept,
            source => $master
        }
    }

}
