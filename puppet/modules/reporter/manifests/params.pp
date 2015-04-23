
class reporter::params {
    $psql_name = hiera('reporter_psql_name', 'psql')
    $base_domain = hiera('base_domain')

    $db_host = "${psql_name}.${base_domain}"
    $db_username = 'reportserver'
    $db_name = 'reportserver'
    $db_password = hiera('reporter_database_password')

    $rs_crypto_pbe_salt = hiera('rs_crypto_pbe_salt')
    $rs_crypto_pbe_passphrase = hiera('rs_crypto_pbe_passphrase')
    $rs_crypto_hmac_passphrase = hiera('rs_crypto_hmac_passphrase')

    $approot = '/var/lib/tomcat7/webapps/reportserver'
    $tomcatconf = '/var/lib/tomcat7/conf/server.xml'

    $port = '8080'
}