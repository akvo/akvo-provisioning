
define backups::server (
    $username, $remote_host, $dest_dir, $port = 22
) {

    notice("Backup server: ${name}")

    file { "/backups/bin/backup_to_${name}.sh":
        ensure  => present,
        owner   => 'backup',
        mode    => '0740',
        content => template('backups/rsync_to_backup_server.sh.erb'),
        require => File['/backups/bin']
    }
}