
class flowexporter::config {

    include flowexporter::params
    $approot = $flowexporter::params::approot

    
    # we want a service address
    named::service_location { "flowexporter":
        ip => hiera('external_ip')
    }
    
    # nginx sits in front of flowexporter
    $base_domain = hiera('base_domain')
    nginx::proxy { "flowexporter.${base_domain}":
        proxy_url  => "http://localhost:${flowexporter::params::port}",
        access_log => "${approot}/logs/flowexporter-nginx-access.log",
        error_log  => "${approot}/logs/flowexporter-nginx-error.log",
    }
    
    
    # let the build server know how to log in to us
    @@teamcity::deploykey { "flowexporter-${::environment}":
        service     => 'flowexporter',
        environment => $::environment,
        key         => hiera('flowexporter-deploy_private_key'),
    }

}