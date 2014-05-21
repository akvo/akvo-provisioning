
class flowreportshim::service {

    include flowreportshim::params
    
    $approot = $flowreportshim::params::approot
    
    # configure a service so we can start and restart flowreportshim
    supervisord::service { "flowreportshim":
        user      => $flowreportshim::params::username,
        command   => "java -jar ${approot}/jars/current.jar",
        directory => $flowreportshim::params::approot,
        env_vars  => {}
    }
    
    # we want the flowreportshim user to be able to restart the process
    sudo::service_control { "flowreportshim":
        user => $flowreportshim::params::username,
    }

}