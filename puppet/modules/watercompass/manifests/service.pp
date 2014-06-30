
class watercompass::service {

    $approot = $watercompass::approot
    $base_domain = hiera('base_domain')
    
    # configure a service so we can start and restart watercompass
    supervisord::service { "watercompass":
        user      => $watercompass::username,
        command   => "${approot}/venv/bin/gunicorn dsp.wsgi --workers 4 --timeout 300 --pid ${approot}/watercompass.pid --bind 127.0.0.1:${watercompass::port}",
        directory => $approot,
        env_vars  => $watercompass::env_vars
    }
    # we want the watercompass user to be able to restart the process
    sudo::service_control { "watercompass":
        user         => $watercompass::username,
    }

}