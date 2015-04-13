
class database::my_sql::backup_support {

    $backupuser = 'backup'
    $backuppassword = hiera('mysql_backup_password')

    mysql_user { "${backupuser}@localhost":
        ensure        => present,
        password_hash => mysql_password($backuppassword),
        provider      => 'mysql',
        require       => Class['mysql::server'],
    }

    mysql_grant { "${backupuser}@localhost/*.*":
        user       => "$backupuser@localhost",
        table      => '*.*',
        privileges => [ 'SELECT', 'RELOAD', 'LOCK TABLES', 'SHOW VIEW' ],
        require    => Mysql_user["${backupuser}@localhost"],
    }

    backups::dest_dir { 'mysql': }

    database::my_sql::backup_db { 'mysql': }

    backups::dir { "mysql":
        path       => "/backups/data/mysql",
        plain_copy => true
    }

}
