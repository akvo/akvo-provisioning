# == Class: akvoplatform
#
# This class installs, configures and manages docker in all akvoplatform nodes.
# By default sets up docker hosted repository, installs docker and any required kernel extension.
#
# It also manages basic mesos installation.
#
class akvoplatform inherits akvoplatform::params {

    class { '::docker':
        version       => $docker_version,
        manage_kernel => true,                  # 'attempt' to install the correct Kernel required by docker
        dns           => $docker_dns            # in some cases dns resolution won't work well in the container unless you give a dns server to the docker daemon
    }

    class { '::mesos':
        version       => $mesos_version,
        zookeeper     => $zk_mesos_url,
        manage_python => true,                  # manage python installation
        repo          => 'mesosphere'           # enable software repositories
    }

    Class['apt'] -> Package<| |>

}
