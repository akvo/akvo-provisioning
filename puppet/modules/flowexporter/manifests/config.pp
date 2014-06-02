
class flowexporter::config inherits flowexporter::params {
    
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

    # create a config file
    file { "${approot}/config.edn":
        ensure  => present,
        owner   => 'flowexporter',
        mode    => '0440',
        content => template('flowexporter/config.edn.erb'),
        require => File[$approot]
    }
    
    
    # let the build server know how to log in to us
    @@teamcity::deploykey { "flowexporter-${::environment}":
        service     => 'flowexporter',
        environment => $::environment,
        key         => hiera('flowexporter-deploy_private_key'),
    }

}