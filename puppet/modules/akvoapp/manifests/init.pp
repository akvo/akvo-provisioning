# This class creates the structure necessary for running an Akvo app. It
# is the place to collect together things required by all Akvo hosted applications

define akvoapp ($deploy_key = undef) {

    $username = $name

    include akvoapp::common

    akvoapp::fs { $name:
        deploy_key => $deploy_key
    }

}