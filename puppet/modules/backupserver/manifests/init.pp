
class backupserver () inherits backupserver::params {

    class { 'backupserver::install': } ->
    class { 'backupserver::config': } ->
    Class['backupserver']

}