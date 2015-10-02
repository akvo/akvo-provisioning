
class akvosites inherits akvosites::params {

    apt::ppa { 'ppa:ondrej/php5-oldstable': } ->

    package { ['php5-gd', 'php5-curl', 'php5']:
        ensure  => installed,
        require => Package['php5-fpm'],
        notify  => Service['php5-fpm']
    }

    package { 'build-essential':
        ensure => installed
    }

    php::app { 'akvosites':
        app_hostnames        => $all_hostnames,
        group                => 'www-edit',
        pool_port            => $pool_port,
        pool_processes       => $pool_processes,
        config_file_contents => template('akvosites/akvosites-nginx.conf.erb')
    }

    file { ["${app_path}/code", "${app_path}/conf"]:
        ensure  => directory,
        owner   => $app_user,
        group   => $app_group,
        mode    => '2775',
        require => File[$app_path]
    }

    backups::dir { "akvosites_code":
        path => "${app_path}/code",
        user => 'root',
    }

    file { "${app_path}/code/wp-config.php":
        ensure  => present,
        owner   => 'akvosites',
        group   => 'akvosites',
        mode    => '0444',
        content => template('akvosites/wp-config.php.erb'),
        require => File["${app_path}/code"]
    }

    file { "${app_path}/scripts":
        ensure  => directory,
        owner   => 'akvosites',
        group   => 'akvosites',
        mode    => '0444',
        require => File[$app_path]
    }

    file { "${app_path}/scripts/update_akvo_sites_data.sh":
        ensure  => present,
        owner   => 'akvosites',
        group   => 'akvosites',
        mode    => '0544',
        content => template('akvosites/update_akvo_sites_data.sh.erb'),
        require => File["${app_path}/scripts"]
    }

    cron { 'update_akvo_sites_data':
        ensure  => present,
        user    => 'akvosites',
        weekday => '*',
        hour    => '6',
        minute  => '0',
        command => "${app_path}/scripts/update_akvo_sites_data.sh",
        require => File["${app_path}/scripts/update_akvo_sites_data.sh"]
    }

    database::my_sql::db { $db_name:
        mysql_name => $mysql_name,
        password   => $db_password,
        reportable => true
    }

    named::service_location { $internal_subdomain:
        ip => hiera('external_ip')
    }

}
