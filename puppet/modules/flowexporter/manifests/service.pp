
class flowexporter::service {

    $approot = $flowexporter::approot
    $jardir = $flowexporter::jardir
    $logdir = $flowexporter::logdir

    $javaopts = "-verbose:gc -Xloggc:${logdir}/flowexporter-gc.log -XX:+PrintGCDetails -XX:+PrintTenuringDistribution -Xmx1024m -d64 -Djava.awt.headless=true"

    # configure a service so we can start and restart flowexporter
    supervisord::service { "flowexporter":
        user      => $flowexporter::params::username,
        command   => "java ${javaopts} -jar ${jardir}/current.jar ${approot}/config.edn",
        directory => $flowexporter::params::approot,
        logdir    => $logdir,
        env_vars  => {}
    }
    
    # we want the flowexporter user to be able to restart the process
    sudo::service_control { "flowexporter":
        user => $flowexporter::params::username,
    }

}