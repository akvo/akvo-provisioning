# == Class: akvoplatform::mesos
#
# This class configures mesos daemons as well as specific mesos components
#
class akvoplatform::mesos inherits akvoplatform::params {

    class { "::akvoplatform::mesos::daemon::${role}": }

    if $role == 'master' {
        include ::akvoplatform::mesos::zookeeper

        # mesos frameworks
        notice('*** Using marathon framework to deploy and manage containers.')
        include ::akvoplatform::mesos::frameworks::marathon
        #TODO include ::akvoplatform::mesos::frameworks::chronos
    }
}
