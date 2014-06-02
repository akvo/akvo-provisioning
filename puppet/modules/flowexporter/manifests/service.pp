
class flowexporter::service {

    include flowexporter::params
    
    $approot = $flowexporter::params::approot
    
    # configure a service so we can start and restart flowexporter
    supervisord::service { "flowexporter":
        user      => $flowexporter::params::username,
        command   => "java -jar ${approot}/jars/current.jar",
        directory => $flowexporter::params::approot,
        env_vars  => {}
    }
    
    # we want the flowexporter user to be able to restart the process
    sudo::service_control { "flowexporter":
        user => $flowexporter::params::username,
    }

}