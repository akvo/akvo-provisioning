# Keycloak supervisord service
class keycloak::service {

  $appdir = $keycloak::appdir

  supervisord::service { 'keycloak':
    user      => 'keycloak',
    directory => "${appdir}/bin",
    command   => "${appdir}/bin/standalone.sh"
  }

  # NOTE: The following command stops Keycloak:
  # ${appdir}/bin/jboss-cli.sh --connect command=:shutdown

}
