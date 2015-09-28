# Keycloak init
class keycloak (
  $appppdir            = $keycloak::params::appdir,
  $approot             = $keycloak::params::approot,
  $db_host             = $keycloak::params::db_host,
  $db_password         = $keycloak::params::db_password,
  $db_name             = $keycloak::params::db_name,
  $db_username         = $keycloak::params::db_username,
  $kc_release          = $keycloak::params::kc_release,
  $port                = $keycloak::params::port,
  $psql_driver_dir     = $keycloak::params::psql_driver_dir,
  $psql_driver_release = $keycloak::params::psql_driver_release
) inherits keycloak::params {

  class { 'keycloak::install': } ->
  class { 'keycloak::config': } ~>
  class { 'keycloak::service': } ->
  Class['keycloak']

}
