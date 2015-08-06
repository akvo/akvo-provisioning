
class keycloak::params {
    $psql_name = hiera('keycloak_psql_name', 'psql')
    $base_domain = hiera('base_domain')

    $db_host = "${psql_name}.${base_domain}"
    $db_username = 'keycloak'
    $db_name = 'keycloak'
    $db_password = hiera('keycloak_database_password')

    $kc_release = 'keycloak-1.3.1.Final'
    $approot = '/opt/keycloak'
    $appdir = "${approot}/${kc_release}"

    $port = '8080'
}
