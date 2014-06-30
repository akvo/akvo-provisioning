
class rundeck {

    class { 'rundeck::install': } ->
    class { 'rundeck::config': } ~>
    class { 'rundeck::service': } ->
    Class['rundeck']
}

