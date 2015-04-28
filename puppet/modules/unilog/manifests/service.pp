class unilog::service inherits unilog::params {

    # configure a service so we can start, stop and restart unilog
    supervisord::service { $appname:
        user      => $username,
        command   => "/opt/leiningen/lein trampoline run -m akvo-unified-log.core ${approot}/config/config.edn",
        directory => $workdir,
        logdir    => $logdir,
        env_vars  => $env_vars
    }

    # we want the unilog user to be able to restart the process
    sudo::service_control { $appname:
        user => $username,
    }

}
