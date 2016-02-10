# external redis modules only work on ubuntu 14.04 and redis >= 2.8
class role::redis {

    notice("Including role: redis")
    
    # running standalone mode
    # listen on every network iface - access limited by firewall
    class { '::redis':
        bind => '0.0.0.0'
    }

}
