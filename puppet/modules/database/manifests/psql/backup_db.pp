define database::psql::backup_db (
                        $hourly = false,
                        $daily = true,
                        $weekly = true,
                        $monthly = true
) {

    $dbname = $name
    $backupuser = 'backup'
    $backuppassword = hiera('psql_backup_password')
    $db_crypto_file = hiera('db_crypto_file')

    $db_grant = "GRANT CONNECT ON DATABASE \"${dbname}\" TO \"${backupuser}\";"
    $table_grant = "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"${backupuser}\";"
    $seq_grant = "GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO \"${backupuser}\";"
    $schema_table_grant = "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"${backupuser}\";"
    $schema_seq_grant = "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO \"${backupuser}\";"

    postgresql_psql { "${dbname}-backup-grant":
        command   => $db_grant,
        db        => $dbname,
        require   => [Class['postgresql::server'], Class['database::psql::backup_support']],
    }
    postgresql_psql { "${dbname}-table-grant":
        command   => $table_grant,
        db        => $dbname,
        require   => [Class['postgresql::server'], Class['database::psql::backup_support']],
    }
    postgresql_psql { "${dbname}-seq-grant":
        command   => $seq_grant,
        db        => $dbname,
        require   => [Class['postgresql::server'], Class['database::psql::backup_support']],
    }
    postgresql_psql { "${dbname}-schema-table-grant":
        command   => $schema_table_grant,
        db        => $dbname,
        require   => [Class['postgresql::server'], Class['database::psql::backup_support']],
    }
    postgresql_psql { "${dbname}-schema-seq-grant":
        command   => $schema_seq_grant,
        db        => $dbname,
        require   => [Class['postgresql::server'], Class['database::psql::backup_support']],
    }

    backups::script { "psqlbackup-${dbname}":
        scriptname => "psqlbackup-${dbname}.sh",
        content    => template('database/psql/backup.sh.erb'),
        require    => Backups::Dest_Dir['psql']
    }

    if $hourly {
        cron { "psql-backup-${dbname}-hourly":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '*',
            minute  => '0',
            command => "/backups/bin/psqlbackup-${dbname}.sh hourly",
            require => Backups::Script["psqlbackup-${dbname}"]
        }
    }

    if $daily {
        cron { "psql-backup-${dbname}-daily":
            ensure  => present,
            user    => 'backup',
            weekday => '*',
            hour    => '2',
            minute  => '5',
            command => "/backups/bin/psqlbackup-${dbname}.sh daily",
            require => Backups::Script["psqlbackup-${dbname}"]
        }
    }

    if $weekly {
        cron { "psql-backup-${dbname}-weekly":
            ensure  => present,
            user    => 'backup',
            weekday => '2',
            hour    => '2',
            minute  => '10',
            command => "/backups/bin/psqlbackup-${dbname}.sh weekly",
            require => Backups::Script["psqlbackup-${dbname}"]
        }
    }

    if $monthly {
        cron { "psql-backup-${dbname}-monthly":
            ensure   => present,
            user     => 'backup',
            monthday => '2',
            hour     => '2',
            minute   => '20',
            command  => "/backups/bin/psqlbackup-${dbname}.sh monthly",
            require  => Backups::Script["psqlbackup-${dbname}"]
        }
    }

}