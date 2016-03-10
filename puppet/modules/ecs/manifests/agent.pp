# == Class: ecs::agent
#
# This class installs and run the ECS agent
#
class ecs::agent {

    # create the host volume mount points
    file { [ "/var/log/ecs", "/etc/ecs", "/var/lib/ecs", "/var/lib/ecs/data" ]:
        ensure => directory
    }

    file { "/etc/ecs/ecs.config":
        ensure => present
    }

    docker::image { 'amazon/amazon-ecs-agent':
        ensure => present
    }->
    docker::run { 'ecs-agent':
        image    => 'amazon/amazon-ecs-agent',
        detach   => true,
        restart  => 'on-failure:10',
        ports    => '51678',
        expose   => '51678',
        env_file => '/etc/ecs/ecs.config',
        volumes  => [
            '/var/run/docker.sock:/var/run/docker.sock',
            '/var/log/ecs:/log',
            '/var/lib/ecs/data:/data',
            '/var/lib/docker:/var/lib/docker',
            '/sys/fs/cgroup:/sys/fs/cgroup:ro',
            '/var/run/docker/execdriver/native:/var/lib/docker/execdriver/native:ro'
        ],
        #ECS_CLUSTER=cluster_name option is not required if working with the default cluster
        env      => [
            'ECS_LOGFILE=/log/ecs-agent.log',
            'ECS_DATADIR=/data/',
            "AWS_DEFAULT_REGION=${aws_region}",
            "AWS_ACCESS_KEY_ID=${aws_access_key}",
            "AWS_SECRET_ACCESS_KEY=${aws_secret_access}"
        ],
        require  => File["/etc/ecs/ecs.config"]
    }

}
