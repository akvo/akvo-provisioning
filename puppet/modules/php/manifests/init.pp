class php {

    package { ['php5-fpm', 'php5-cgi', 'php5-mysql']:
        ensure => installed,
        notify => Service['php5-fpm']
    }

    file { '/etc/php5/fpm/php.ini':
        ensure  => present,
        source  => 'puppet:///modules/homepage/php.ini',
        owner   => root,
        mode    => '0444',
        require => Package['php5-fpm'],
        notify  => Service['php5-fpm']
    }

    service { 'php5-fpm':
        ensure => running
    }

}
