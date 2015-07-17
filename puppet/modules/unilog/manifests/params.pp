class unilog::params {

    $username            = 'unilog'
    $appname             = 'unilog'
    $approot             = "/var/akvo/${appname}"
    $workdir             = "${approot}/code"
    $logdir              = "${approot}/logs"
    $appport             = '3030'
    $env_vars            = {
        'HOME' => $approot
    }

    $remote_api_email    = 'reports@akvoflow.org'
    $remote_api_password = hiera('unilog_remote_api_password')

    $flow_server_config  = "${approot}/akvo-flow-server-config"
    $flow_data_schema    = "${approot}/resources/schema/event.json"

    $base_domain         = hiera('base_domain')
    $main_domain         = hiera('unilog_main_domain', "unilog.${base_domain}")
    $postgres_name       = hiera('psql_name')
    $postgres_host       = "${postgres_name}.${base_domain}"
    $postgres_port       = hiera('psql_port', '5432')
    $postgres_clients    = hiera_hash('unilog_psql_clients')
    $database_password   = hiera('unilog_database_password')

}
