class unilog::params {

    $username            = 'unilog'
    $appname             = 'unilog'
    $approot             = "/var/akvo/${appname}"
    $workdir             = "${approot}/code"
    $logdir              = "${approot}/logs"
    $port                = '3030'
    $env_vars            = {
        'HOME' => $approot
    }

    $remote_api_email    = 'reports@akvoflow.org'
    $remote_api_password = hiera('unilog_remote_api_password')

    $flow_server_config  = "${approot}/akvo-flow-server-config"
    $flow_data_schema    = "${approot}/akvo-core-services/flow-data-schema/schema/event.json"

    $main_domain         = hiera('unilog_main_domain', "unilog.${base_domain}")
    $postgres_name       = hiera('psql_name')
    $database_password   = hiera('unilog_database_password')

}
