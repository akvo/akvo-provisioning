
define backups::server (
    $username, $remote_host, $dest_dir, $host_key, $port = 22
) {

    notice("Backup server: ${name}")

    file { "/backups/bin/diff_backup_to_${name}.sh":
        ensure  => present,
        owner   => 'backup',
        mode    => '0740',
        content => template('backups/diff_copy.sh.erb'),
        require => File['/backups/bin']
    }

    file { "/backups/bin/plain_backup_to_${name}.sh":
        ensure  => present,
        owner   => 'backup',
        mode    => '0740',
        content => template('backups/plain_copy.sh.erb'),
        require => File['/backups/bin']
    }

    ssh_key { "backup-server-${name}":
        ensure => present,
        name   => $remote_host,
        type   => 'rsa',
        key    => $host_key
    }

}