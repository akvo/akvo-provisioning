# == Class: ecs
#
# This class installs docker and the Amazon ECS container agent on non-Amazon Linux EC2 instances.
#
class ecs inherits ecs::params {

    class { '::docker':
        version       => $docker_version,
        manage_kernel => true,                  # 'attempt' to install the correct Kernel required by docker
        dns           => $docker_dns            # in some cases dns resolution won't work well in the container unless you give a dns server to the docker daemon
    }

    # create the host volume mount points
    file { [ "/var/log/ecs", "/etc/ecs", "/var/lib/ecs/data" ]:
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
