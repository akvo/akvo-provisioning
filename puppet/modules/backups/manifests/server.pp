
define backups::server (
    $username, $remote_host, $port = 22, $dest_dir
) {

    notice("Backup server: $name")

    file { "/backups/bin/backup_to_${name}.sh":
        ensure  => present,
        owner   => 'backup',
        mode    => 740,
        content => template('backups/rsync_to_backup_server.sh.erb'),
        require => File['/backups/bin']
    }
}