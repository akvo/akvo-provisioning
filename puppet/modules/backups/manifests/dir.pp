
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
    $script_name = "/backups/bin/backup-${name}.sh"

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
        cron { "backup-dir-${name}-hourly":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '3',
            minute  => '0',
            command => "/backups/bin/$script_name hourly",
            require => File[$script_name]
        }
    }

    if $weekly {
        cron { "backup-dir-${name}-hourly":
            ensure  => present,
            user    => 'backup',
            weekday => '2',
            hour    => '4',
            minute  => '0',
            command => "/backups/bin/$script_name hourly",
            require => File[$script_name]
        }
    }

    if $monthly {
        cron { "backup-dir-${name}-hourly":
            ensure   => present,
            user     => 'backup',
            monthday => '4',
            hour     => '5',
            minute   => '0',
            command  => "/backups/bin/$script_name hourly",
            require  => File[$script_name]
        }
    }

}