
class tessera::params {

    $port = 8450
    $approot = '/opt/tessera'
    $mysql_name = hiera('tessera_mysql_name', 'mysql')
    $base_domain = hiera('base_domain')
    $dbhost = "${mysql_name}.${base_domain}"
    $dbname = 'tessera'
    $database_password = hiera('tessera_database_password')
    $secret_key = hiera('tessera_secret_key')
    $graphite_host = hiera('graphite_host')

}