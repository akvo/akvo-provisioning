
# Creating a resource of this type results in the contents of a directory being backed
# up onto the list of backup servers.
#
# Params:
#    $path
#      - The path to the directory to back up
#    $hourly, $daily, $weekly, $monthly
#      - Whether the backups should be run hourly, daily etc. The default is not to run hourly
#        but to run daily, weekly and monthly
#    $retain_count
#      - How many backups of each periodicity should be kept. The default is 4, meaning 4 daily,
#        4 weekly and 4 monthly backups will be kept. This is ignored if using $plain_copy,
#        as it is assumed that the source directory will be managed outside of this resource.
#    $plain_copy
#      - Whether to simply synchronise the backup folder on the current system with the
#        target backup servers (true) or to use rsyncing/hardlinks to provide a 'diff-based'
#        backup strategy where only the file changes need to be copied (false).
#        Plain copy should be used when new files are created every day and old files are never
#        changed, for example, daily MySQL dumps. For variable assets such as Wordpress PHP
#        files or RSR media assets, plain copy should not be used. The default is 'false'.

define backups::dir (
    $path,
    $hourly = false,
    $daily = true,
    $weekly = true,
    $monthly = true,
    $retain_count = 4,
    $plain_copy = false,
) {

    $backup_servers = hiera_hash('backup_servers')
    $backup_bin_dir = '/backups/bin/'
    $backup_logs_dir = '/backups/logs/'
    $script_name = "${backup_bin_dir}/backup-${name}.sh"

    if $plain_copy {
        $script_prefix = 'plain'
    } else {
        $script_prefix = 'diff'
    }

    file { $script_name:
        ensure  => present,
        owner   => backup,
        mode    => '0700',
        content => template('backups/backup_directory.sh.erb')
    }

    if $hourly {
        cron { "backup-dir-${name}-hourly":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '*',
            minute  => '30',
            command => "${script_name} hourly",
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
            command => "${script_name} daily",
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
            command => "${script_name} weekly",
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
            command  => "${script_name} monthly",
            require  => File[$script_name]
        }
    }

}