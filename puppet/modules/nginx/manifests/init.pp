
class nginx {

    package { 'nginx':
        ensure => installed,
    }

    service { 'nginx':
        require    => Package['nginx'],
        ensure     => running,
        enable     => true,
        hasrestart => true,
    }

    class { 'collectd::plugin::nginx':
        url => 'http://localhost:8181/status'
    }

    file { '/etc/nginx/certs':
        ensure  => 'directory',
        owner   => 'www-data',
        mode    => '0700',
        require => Package['nginx'],
    }

    file { '/etc/nginx/passwd':
        ensure  => 'directory',
        owner   => 'www-data',
        mode    => '0700',
        require => Package['nginx'],
    }

    file { '/etc/nginx/sites-enabled/default':
        ensure  => absent,
        require => Package['nginx'],
    }

    file { '/etc/nginx/sites-enabled/server_status':
        ensure  => present,
        owner   => 'www-data',
        mode    => 444,
        source  => 'puppet:///modules/nginx/server_status',
        require => Package['nginx'],
    }

}
