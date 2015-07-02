
class keycloak::service {

    supervisord::service { 'keycloak':
        user      => 'keycloak',
        directory   => '/opt/keycloak/keycloak-1.3.1.Final/bin',
        command   => '/opt/keycloak/keycloak-1.3.1.Final/bin/standalone.sh',
    }

}