# == Class: ecs
#
# This class installs docker and the Amazon ECS container agent on non-Amazon Linux EC2 instances.
#
class ecs inherits ecs::params {

    class { '::docker':
        version       => $docker_version,
        manage_kernel => true,                    # 'attempt' to install the correct Kernel required by docker
        root_dir      => '/puppet/var/lib/docker' # change docker's storage base directory to encrypted partition
    } ->
    class { 'ecs::nginx': } ->
    class { 'ecs::agent': }

}
