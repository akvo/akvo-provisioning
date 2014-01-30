
class butler::service {

    include butler::params

    $approot = $butler::params::approot
    $base_domain = hiera('base_domain')

    # configure a service so we can start and restart butler
    supervisord::service { "butler_web":
        user      => $butler::params::username,
        command   => "${approot}/venv/bin/django-admin.py run_gunicorn --pid ${approot}/butler.pid --bind 127.0.0.1:${butler::params::port}",
        directory => $butler::params::approot,
        env_vars  => $butler::params::env_vars
    }

    supervisord::service { "butler_worker":
        user      => $butler::params::username,
        command   => "${approot}/venv/bin/celery worker --config butler.settings --beat --events --loglevel info",
        directory => $butler::params::approot,
        env_vars  => $butler::params::env_vars
    }

    # we want the butler user to be able to restart the process
    sudo::service_control { ["butler_web", "butler_worker"]:
        user => $butler::params::username,
    }

}