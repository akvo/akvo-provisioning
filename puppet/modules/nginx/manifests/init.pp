
class nginx {

    $set_limits = hiera('nginx_set_limits', false)
    $limit_req_zone_rate = hiera('nginx_limit_req_zone_rate', false)

    ensure_resource('package', 'nginx', { ensure => present })

    ensure_resource('service', 'nginx', {
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true
    })

    common::collectd_plugin { 'nginx':
        args => {
            url => 'http://localhost:8181/status'
        }
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
        mode    => '0444',
        source  => 'puppet:///modules/nginx/server_status',
        require => Package['nginx'],
    }

    firewall { '200 allow httpd access':
        port   => [80, 443],
        proto  => tcp,
        action => accept,
    }

    if $set_limits {
        file_line { 'nginx_limit':
            ensure  => present,
            path    => '/etc/nginx/nginx.conf',
            line    => "limit_req_zone \$binary_remote_addr zone=myzone:10m rate=${limit_req_zone_rate}r/m;",
            match   => '# server_tokens off;',
            require => File['/etc/nginx/sites-enabled/server_status']
        }
    }

}
