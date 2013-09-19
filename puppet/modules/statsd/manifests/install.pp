
class statsd::install {

    ensure_packages(['git', 'nodejs'])

    user { 'statsd':
        ensure => present,
        home   => '/opt/statsd',
        shell  => '/bin/bash'
    }

    file { '/opt/statsd':
        ensure  => directory,
        owner   => 'statsd',
        group   => 'statsd',
        mode    => '0700',
        require => User['statsd']
    }

    exec { 'clone_statsd':
        command => '/usr/bin/git clone https://github.com/etsy/statsd.git /opt/statsd',
        creates => '/opt/statsd/.git',
        cwd     => '/opt/statsd',
        user    => 'statsd',
        require => File['/opt/statsd']
    }

}