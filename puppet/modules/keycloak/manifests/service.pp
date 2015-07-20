
class keycloak::service {

    $appdir = $keycloak::appdir

    supervisord::service { 'keycloak':
        user      => 'keycloak',
        directory   => '${appdir}/bin',
        command   => '${appdir}/bin/standalone.sh',
    }

}