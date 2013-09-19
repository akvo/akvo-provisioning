
class graphite::service {

    debug("Configuring graphite service")

    supervisord::service { 'carbon':
        user      => 'graphite',
        command   => "/opt/graphite/venv/bin/python /opt/graphite/bin/carbon-cache.py --debug start",
        directory => "/opt/graphite",
    }

    supervisord::service { 'graphite-web':
        user => 'graphite',
        command => '/opt/graphite/venv/bin/gunicorn_django -u graphite -g graphite -b 127.0.0.1:5115 /opt/graphite/webapp/graphite/settings.py',
        directory => '/opt/graphite'
    }

}