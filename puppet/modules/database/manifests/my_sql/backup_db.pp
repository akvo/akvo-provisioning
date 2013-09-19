define database::my_sql::backup_db (
    $hourly = false,
    $daily = true,
    $weekly = true,
    $monthly = true
) {
    $dbname = $name

    $backuppassword = hiera('mysql_backup_password')
    backups::script { "mysqlbackup-${dbname}":
        scriptname => "mysqlbackup-${dbname}.sh",
        content    => template('database/mysql/backup.sh.erb'),
        require    => Backups::Dir['mysql']
    }

    if $hourly {
        cron { "mysql-backup-${dbname}-hourly":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '*',
            minute  => '0',
            command => "/backups/bin/mysqlbackup-${dbname}.sh hourly",
            require => Backups::Script["mysqlbackup-${dbname}"]
        }
    }

    if $daily {
        cron { "mysql-backup-${dbname}-daily":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '3',
            minute  => '5',
            command => "/backups/bin/mysqlbackup-${dbname}.sh daily",
            require => Backups::Script["mysqlbackup-${dbname}"]
        }
    }

    if $weekly {
        cron { "mysql-backup-${dbname}-weekly":
            ensure  => present,
            user    => 'backup',
            weekday => '2',
            hour    => '3',
            minute  => '10',
            command => "/backups/bin/mysqlbackup-${dbname}.sh weekly",
            require => Backups::Script["mysqlbackup-${dbname}"]
        }
    }

    if $monthly {
        cron { "mysql-backup-${dbname}-monthly":
            ensure   => present,
            user     => 'backup',
            monthday => '2',
            hour     => '3',
            minute   => '20',
            command  => "/backups/bin/mysqlbackup-${dbname}.sh monthly",
            require  => Backups::Script["mysqlbackup-${dbname}"]
        }
    }


    backups::dir { "mysql":
        path => "/backups/data/mysql"
    }

}