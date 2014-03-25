
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
        ensure  => present,
        owner   => 'www-data',
        mode    => 444,
        source  => 'puppet:///modules/nginx/default',
        require => Package['nginx'],
    }

}
