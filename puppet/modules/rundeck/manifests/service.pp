
class rundeck::service {

    service { 'rundeckd':
        ensure => 'running',
        hasrestart => true,
        hasstatus => true,
    }

}