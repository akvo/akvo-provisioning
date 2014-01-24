
class flowreportshim::config {

    include flowreportshim::params
    $approot = $flowreportshim::params::approot

    
    # we want a service address
    named::service_location { "flowreportshim":
        ip => hiera('external_ip')
    }
    
    # nginx sits in front of flowreportshim
    $base_domain = hiera('base_domain')
    nginx::proxy { "flowreportshim.${base_domain}":
        proxy_url  => "http://localhost:${flowreportshim::params::port}",
        access_log => "${approot}/logs/flowreportshim-nginx-access.log",
        error_log  => "${approot}/logs/flowreportshim-nginx-error.log",
    }
    
    
    # let the build server know how to log in to us
    @@teamcity::deploykey { "flowreportshim-${::environment}":
        service     => 'flowreportshim',
        environment => $::environment,
        key         => hiera('flowreportshim-deploy_private_key'),
    }

}