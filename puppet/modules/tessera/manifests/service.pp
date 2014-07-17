
class tessera::service {

    include tessera::params

    $approot = $tessera::params::approot
    $base_domain = hiera('base_domain')

    # configure a service so we can start and restart RSR
    supervisord::service { "tessera":
        user      => 'tessera',
        command   => "${approot}/venv/bin/gunicorn tessera:app --max-requests 200 --workers 5 --timeout 300 --pid ${approot}/tessera.pid --bind 127.0.0.1:${tessera::params::port}",
        directory => $tessera::params::approot,
        env_vars  => {
            'TESSERA_CONFIG' => "${approot}/config.py",
            'PYTHONPATH' => "${approot}/code/"
        }
    }

    sudo::service_control { "tessera":
        user         => 'tessera',
    }
}