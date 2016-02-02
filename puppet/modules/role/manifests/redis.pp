# external redis modules only work on ubuntu 14.04 and redis >= 2.8
class role::redis {

    notice("Including role: redis")
    
    # running standalone mode
    class { '::redis': } 

}
