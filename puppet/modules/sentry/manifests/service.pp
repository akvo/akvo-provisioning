
class sentry::service {

    supervisord::service { 'sentry':
        user      => 'sentry',
        command   => '/opt/sentry/venv/bin/sentry --config=/opt/sentry/conf.py start',
        directory => '/opt/sentry',
    }

}