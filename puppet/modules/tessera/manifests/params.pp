
class tessera::params {

    $port = 8450
    $approot = '/opt/tessera'
    $dbname = 'tessera'
    $database_password = hiera('tessera_database_password')
    $secret_key = hiera('tessera_secret_key')
    $graphite_host = hiera('graphite_host')

}