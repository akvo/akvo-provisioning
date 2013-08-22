
class graphite::server {
    include pythonsupport::standard
    include pythonsupport::mysql
    include pythonsupport::pycairo

    user { 'graphite':
        ensure => present,
        home => '/opt/graphite',
    }

    group { 'graphite':
        ensure => present,
    }

    $required_packages = [
        'graphite-web',
        'whisper',
        'carbon',
        'gunicorn',
        'django',
        'twisted',
        'django-tagging',
        'simplejson',
        'MySQL-python',
    ]
    ensure_resource( 'package', $required_packages, {
        ensure   => installed,
        provider => 'pip',
        before   => Exec['graphite-ownership'],
    })

    package { 'python-cairo': # becuase pycairo doesn't have a setup.py so can't be installed by pip..
        ensure => installed,
    }

    exec { 'graphite-ownership':
        command => '/bin/chown -R graphite.graphite /opt/graphite',
        require => [User['graphite'], Group['graphite']]
    }

    file { '/opt/graphite/conf/storage-schemas.conf':
        ensure  => present,
        source  => 'puppet:///modules/graphite/storage-schemas.conf',
        owner   => 'graphite',
        group   => 'graphite',
        mode    => '444',
        require => [Package['whisper'], Package['carbon']],
    }

    file { '/opt/graphite/conf/carbon.conf':
        ensure  => present,
        source  => 'puppet:///modules/graphite/carbon.conf',
        owner   => 'graphite',
        group   => 'graphite',
        mode    => '444',
        require => Package['carbon'],
    }

    supervisord::service { 'carbon':
        user      => 'graphite',
        command   => "/usr/bin/python /opt/graphite/bin/carbon-cache.py --debug start",
        directory => "/opt/graphite",
    }

    supervisord::service { 'graphite-web':
        user => 'graphite',
        command => 'gunicorn_django -u graphite -g graphite -b 127.0.0.1:5115 /opt/graphite/webapp/graphite/settings.py',
        directory => '/opt/graphite'
    }

    $secret_key = hiera('graphite_secret_key')
    $database_host = hiera('graphite_database_host')
    $database_name = hiera('graphite_database_name')
    $database_user = hiera('graphite_database_user')
    $database_password = hiera('graphite_database_password')


    database::my_sql::db { $database_user:
        password => $database_password
    }

    file { '/opt/graphite/webapp/graphite/local_settings.py':
        ensure  => present,
        owner   => 'graphite',
        group   => 'graphite',
        mode    => 444,
        require => Package['graphite-web'],
        content => template('graphite/graphite_settings.py.erb'),
    }


    named::service_location { "graphite":
        ip => hiera('external_ip')
    }

    $base_domain = hiera('base_domain')
    nginx::proxy { "graphite.${base_domain}":
        proxy_url          => "http://localhost:5115",
    }


}