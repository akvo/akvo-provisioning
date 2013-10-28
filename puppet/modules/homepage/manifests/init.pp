
class homepage {

    include akvoapp

    $wwwroot = '/var/akvo/homepage'
    $db_host = 'mysql'
    $db_password = hiera('homepage_wordpress_database_password')
    $specified_hostnames = hiera('homepage_hostnames')
    $base_domain = hiera('base_domain')
    $default_hostname = ["homepage.${base_domain}"]
    $homepage_hostnames = concat($default_hostname, $specified_hostnames)

    package { ['php5-fpm', 'php5-cgi', 'php5-mysql']:
        ensure => installed
    }

    file { '/etc/php5/fpm/php.ini':
        ensure  => present,
        source  => 'puppet:///modules/homepage/php.ini',
        owner   => root,
        mode    => '0444',
        require => Package['php5-fpm']
    }

    user { 'homepage':
        ensure => present,
        home   => $wwwroot,
        shell  => '/bin/bash',
        groups => ['homepage']
    }

    group { 'homepage':
        ensure => present
    }

    group { 'www-edit':
        ensure => present
    }

    nginx::configfile { 'homepage':
        content => template('homepage/homepage-nginx.conf.erb')
    }

    file { [$wwwroot, "${wwwroot}/wordpress"]:
        ensure  => directory,
        owner   => 'homepage',
        group   => 'www-edit',
        mode    => '0775',
        require => File['/var/akvo']
    }

    file { "${wwwroot}/logs":
        ensure  => directory,
        owner   => 'www-data',
        group   => 'www-edit',
        mode    => '0755',
        require => File['/var/akvo']
    }

    file { "${wwwroot}/wordpress/wp-config.php":
        ensure  => present,
        owner   => 'homepage',
        group   => 'homepage',
        mode    => '0444',
        content => template('homepage/wp-config.php.erb'),
        require => File["${wwwroot}/wordpress"]
    }

    backups::dir { "homepage":
        path => $wwwroot
    }

    database::my_sql::db { 'homepage':
        password => $db_password
    }

}
