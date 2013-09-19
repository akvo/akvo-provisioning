
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

    file { "/backups/bin/backup-${name}.sh":
        ensure => present,
        owner => backup,
        mode => 700,
        content => template('backups/backup_directory.sh.erb')
    }

}