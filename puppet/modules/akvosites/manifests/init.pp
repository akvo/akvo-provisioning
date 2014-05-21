
class akvosites {

    $db_host = 'mysql'
    $db_password = hiera('akvosites_database_password')

    $akvosites_hostnames = hiera('akvosites_hostnames')
    $app_path = '/var/akvo/akvosites'

    package { ['php5-gd', 'php5-curl']:
        ensure  => installed,
        require => Package['php5-fpm'],
        notify  => Service['php5-fpm']
    }

    php::app { 'akvosites':
        app_hostnames        => $akvosites_hostnames,
        group                => 'www-edit',
        wordpress            => true,
        nginx_writable       => true,
        config_file_contents => template('akvosites/akvosites-nginx.conf.erb')
    }

    backups::dir { "akvosites_code":
        path => "${app_path}/code"
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

    file { "${app_path}/scripts/sync_sites_updates.sh":
        ensure  => present,
        owner   => 'akvosites',
        group   => 'akvosites',
        mode    => '0544',
        content => template('akvosites/sync_sites_updates.sh.erb'),
        require => File["${app_path}/scripts"]
    }

    cron { 'sync_sites_updates':
        ensure  => present,
        user    => 'akvosites',
        weekday => '*',
        hour    => '*/6',
        minute  => '15',
        command => "${app_path}/scripts/sync_sites_updates.sh",
        require => File["${app_path}/scripts/sync_sites_updates.sh"]
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
        hour    => '*/3',
        minute  => '5',
        command => "${app_path}/scripts/update_akvo_sites_data.sh",
        require => File["${app_path}/scripts/update_akvo_sites_data.sh"]
    }

    database::my_sql::db { 'akvosites':
        password   => $db_password,
        reportable => true
    }

    named::service_location { 'akvosites':
        ip => hiera('external_ip')
    }

}