
class sanitationcompass::config {

    database::my_sql::db { 'sanitationcompass':
        password   => $sanitationcompass::database_password,
        reportable => false
    }


    named::service_location { 'sanitationcompass':
        ip => hiera('external_ip')
    }


    $base_domain = hiera('base_domain')
    nginx::proxy { ["sanitationcompass.${base_domain}", 'sanitationcompass.info']:
        proxy_url          => "http://localhost:${sanitationcompass::port}",
        static_dirs        => {
            "/media/admin/" => "${approot}/venv/lib/python2.7/site-packages/django/contrib/admin/static/admin/",
            "/media/"       => $rsr::params::media_root
        },
        access_log          => "${approot}/logs/nginx-access.log",
        error_log           => "${approot}/logs/nginx-error.log",
    }
}