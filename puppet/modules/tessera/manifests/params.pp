
class tessera::params {

    $port = 8450
    $approot = '/opt/tessera'
    $dbname = 'tessera'
    $database_password = hiera('tessera_database_password')

}