
class sanitationcompass::service {

    $approot = $sanitationcompass::approot
    $base_domain = hiera('base_domain')
    
    # configure a service so we can start and restart sanitationcompass
    supervisord::service { "sanitationcompass":
        user      => $sanitationcompass::username,
        command   => "${approot}/venv/bin/gunicorn dsp.wsgi --workers 4 --timeout 300 --pid ${approot}/sanitationcompass.pid --bind 127.0.0.1:${sanitationcompass::port}",
        directory => $approot,
        env_vars  => $sanitationcompass::env_vars
    }
    # we want the sanitationcompass user to be able to restart the process
    sudo::service_control { "sanitationcompass":
        user         => $sanitationcompass::username,
    }

}