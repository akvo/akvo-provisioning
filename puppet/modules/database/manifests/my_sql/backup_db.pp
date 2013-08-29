define database::my_sql::backup_db {
    $dbname = $name

    $backuppassword = hiera('mysql_backup_password')
    backups::script { "mysqlbackup-${dbname}":
        scriptname => "mysqlbackup-${dbname}.sh",
        content    => template('database/mysql/backup.sh.erb'),
        require    => Backups::Dir['mysql']
    }

    cron { "mysql-backup-${dbname}-daily":
        ensure  => present,
        user    => 'backup',
        weekday => '*',
        hour    => '3',
        minute  => '0',
        command => "/backups/bin/mysqlbackup-${dbname}.sh",
        require => Backups::Script['mysqlbackup']
    }

}