
class rsr::service {

    include rsr::params

    $base_domain = hiera('base_domain')

    # add custom configuration
    $use_graphite = hiera("rsr_use_graphite", false)
    if $use_graphite {
        $statsd_host = hiera('statsd_host', "statsd.${base_domain}")
        $statsd_port = 8125
        $statsd_prefix = "rsr.${::environment}"
    }


    # configure a service so we can start and restart RSR
    supervisord::service { "rsr":
        user      => $rsr::params::username,
        command   => "${rsr::params::approot}/venv/bin/gunicorn akvo.wsgi --max-requests 200 --workers 5 --timeout 300 --pid ${rsr::params::approot}/rsr.pid --bind 127.0.0.1:${rsr::params::port}",
        directory => $rsr::params::approot,
        env_vars  => {
            'PYTHONPATH' => "${rsr::params::approot}/code/"
        }
    }
    # we want the rsr user to be able to restart the process
    sudo::service_control { "rsr":
        user         => $rsr::params::username,
    }

}