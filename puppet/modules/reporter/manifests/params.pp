
class reporter::params {
    $psql_name = hiera('reporter_psql_name', 'psql-reportserver')
    $base_domain = hiera('base_domain')

    $db_host = 'localhost'
    $db_username = 'reportserver3'
    $db_name = 'reportserver3'
    $db_password = hiera('reporter_database_password')

    $postgres_name       = hiera('psql_name')
    $postgres_host       = "${postgres_name}.${base_domain}"
    $postgres_port       = hiera('psql_port', '5432')
    $database_password   = hiera('reporter_database_password')

    $rs_crypto_pbe_salt = hiera('rs_crypto_pbe_salt')
    $rs_crypto_pbe_passphrase = hiera('rs_crypto_pbe_passphrase')
    $rs_crypto_hmac_passphrase = hiera('rs_crypto_hmac_passphrase')

    $approot = '/var/lib/tomcat7/webapps/reportserver3'
    $tomcatconf = '/var/lib/tomcat7/conf/server.xml'

    $port = '8080'
}