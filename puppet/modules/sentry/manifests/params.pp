
class sentry::params {
    $psql_name = hiera('sentry_psql_name', 'psql')
    $base_domain = hiera('base_domain')

    $db_host = "${psql_name}.${base_domain}"
    $db_username = 'sentry'
    $db_name = 'sentry'
    $db_password = hiera('sentry_database_password')

    $secret_key = hiera('sentry_secret_key')

    $port = 5101

}