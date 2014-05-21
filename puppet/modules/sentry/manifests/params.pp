
class sentry::params {

    $db_username = 'sentry'
    $db_name = 'sentry'
    $db_password = hiera('sentry_database_password')

    $secret_key = hiera('sentry_secret_key')

    $port = 5101

}