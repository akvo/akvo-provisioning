
class keycloak::service {

    supervisord::service { 'tomcat7':
        user      => 'root',
        command   => '/etc/init.d/tomcat7 start',
    }

}