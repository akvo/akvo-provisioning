
define backups::dir (
    $path,
    $hourly = false,
    $daily = true,
    $weekly = true,
    $monthly = true,
    $retain_count = 4
) {

    $backup_servers = hiera_hash('backup_servers')
    $backup_bin_dir = '/backups/bin/'
    $script_name = "${backup_bin_dir}/backup-${name}.sh"

    file { $script_name:
        ensure => present,
        owner => backup,
        mode => 700,
        content => template('backups/backup_directory.sh.erb')
    }

    if $hourly {
        cron { "backup-dir-${name}-hourly":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '*',
            minute  => '30',
            command => "/backups/bin/$script_name hourly",
            require => File[$script_name]
        }
    }

    if $daily {
        cron { "backup-dir-${name}-daily":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '3',
            minute  => '0',
            command => "$script_name daily",
            require => File[$script_name]
        }
    }

    if $weekly {
        cron { "backup-dir-${name}-weekly":
            ensure  => present,
            user    => 'backup',
            weekday => '2',
            hour    => '4',
            minute  => '0',
            command => "$script_name weekly",
            require => File[$script_name]
        }
    }

    if $monthly {
        cron { "backup-dir-${name}-monthly":
            ensure   => present,
            user     => 'backup',
            monthday => '4',
            hour     => '5',
            minute   => '0',
            command  => "$script_name monthly",
            require  => File[$script_name]
        }
    }

}