class keycloak::params {

  $psql_name = hiera('keycloak_psql_name', 'psql')
  $base_domain = hiera('base_domain')

  $db_host = "${psql_name}.${base_domain}"
  $db_username = 'keycloak'
  $db_name = 'keycloak'
  $db_password = hiera('keycloak_database_password')

  $kc_release = '1.4.0.Final'
  $approot = '/opt/keycloak'
  $appdir = "${approot}/keycloak-${kc_release}"

  $psql_release = '9.3-1100-jdbc4'
  $psql_dir = "${appdir}/modules/system/layers/base/org/postgresql/jdbc/main"

  $port = '8080'

}
