# This class pulls together the parts which are required by both installed
# and development versions of RSR

class rsr::common {
    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    require akvoapp

    # include our RSR-specific akvo info
    akvoapp::app { 'rsr': } # no parameters yet

    # create an RSR database on the database server
    @@database::psql::db { 'rsr':
        password => 'lake'
    }

}