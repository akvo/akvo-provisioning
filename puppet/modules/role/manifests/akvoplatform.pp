class role::akvoplatform {

    notice("Including role: Akvo platform.")

    ## common profiles for either 'master' or 'slave' roles
    # docker & mesos basic installation
    include ::akvoplatform
    # mesos daemon & specific mesos components depending on node role
    include ::akvoplatform::mesos
    # consul for service discovery
    include ::akvoplatform::consul

    ## role-specific profiles
    case $role {
        'master': {
            # proxy to microservices provided by containers running on top of Akvo platform
            include ::akvoplatform::proxy
        }
        'slave': {
            # service registry bridge for docker, with pluggable adapters (including consul)
            include ::akvoplatform::registrator
        }
    }
}
