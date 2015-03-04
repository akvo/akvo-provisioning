
class reporter::params {
    $psql_name = hiera('reporter_psql_name', 'psql')
    $base_domain = hiera('base_domain')

    $db_host = "${psql_name}.${base_domain}"
    $db_username = 'foo'
    $db_name = 'reportserver22'
    $db_password = hiera('reporter_database_password')

    $approot = '/var/lib/tomcat7/webapps/reportserver'

    $port = '8080'
}