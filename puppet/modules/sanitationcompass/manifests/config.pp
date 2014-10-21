
class sanitationcompass::config {

    named::service_location { 'sanitationcompass':
        ip => hiera('external_ip')
    }


    $base_domain = hiera('base_domain')
    nginx::proxy { ["sanitationcompass.${base_domain}", 'sanitationcompass.info']:
        proxy_url          => "http://localhost:${sanitationcompass::port}",
        static_dirs        => {
            "/static/" => "${sanitationcompass::approot}/code/dsp/dsp/dsp-static/",
        },
        access_log          => "${sanitationcompass::approot}/logs/nginx-access.log",
        error_log           => "${sanitationcompass::approot}/logs/nginx-error.log",
    }


    @@teamcity::deploykey { "sanitationcompass-${::environment}":
        service     => 'sanitationcompass',
        environment => $::environment,
        key         => hiera('sanitationcompass-deploy_private_key'),
    }
}