
class reporter::service {

    supervisord::service { 'tomcat7':
        user      => 'tomcat7',
        command   => '/etc/init.d/tomcat7 start',
    }

}