
class role::keycloak {

    notice('Including role: keycloak')
    class { '::keycloak': }
    
}
