# == Class: akvoplatform::registrator
#
# This class manages a running registrator container.
# We use 'consul' as the service registry backend.
#
#TODO consul health checks - https://github.com/gliderlabs/registrator#consul-health-checks
#TODO '-cleanup' param - https://github.com/gliderlabs/registrator/pull/193
#
class akvoplatform::registrator inherits akvoplatform::params {

    docker::image { 'gliderlabs/registrator':
        ensure => 'present'
    }->

    docker::run { 'registrator-app':
        image              => 'gliderlabs/registrator',
        hostname           => $::fqdn,
        volumes            => ['/var/run/docker.sock:/tmp/docker.sock'],
        command            => "consul://${consul_backend}",
        memory_limit       => '64m',
        use_name           => true,
        restart_service    => true,
        privileged         => false,
        pull_on_start      => false,
    }

}
