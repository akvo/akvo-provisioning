
class watercompass::config {

    named::service_location { 'watercompass':
        ip => hiera('external_ip')
    }


    $base_domain = hiera('base_domain')
    nginx::proxy { ["watercompass.${base_domain}", 'watercompass.info', 'watercompass.nl', 'watercompass.org']:
        proxy_url          => "http://localhost:${watercompass::port}",
        static_dirs        => {
            "/static/" => "${watercompass::approot}/code/dsp/dst/static/",
        },
        access_log          => "${watercompass::approot}/logs/nginx-access.log",
        error_log           => "${watercompass::approot}/logs/nginx-error.log",
    }


    @@teamcity::deploykey { "watercompass-${::environment}":
        service     => 'watercompass',
        environment => $::environment,
        key         => hiera('watercompass-deploy_private_key'),
    }
}