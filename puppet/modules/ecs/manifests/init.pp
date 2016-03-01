# == Class: ecs
#
# This class installs docker and the Amazon ECS container agent on non-Amazon Linux EC2 instances.
#
class ecs inherits ecs::params {

    class { '::docker':
        version       => $docker_version,
        manage_kernel => true,                  # 'attempt' to install the correct Kernel required by docker
        dns           => $docker_dns            # in some cases dns resolution won't work well in the container unless you give a dns server to the docker daemon
    } ->
    class { 'ecs::nginx': } ->
    class { 'ecs::agent': }

}
