
class database::my_sql::backup_support {

    $backupuser = 'backup'
    $backuppassword = hiera('mysql_backup_password')

    mysql_user { "${backupuser}@localhost":
        ensure        => present,
        password_hash => mysql_password($backuppassword),
        provider      => 'mysql',
        require       => Class['mysql::server'],
    }

    mysql_grant { "${backupuser}@localhost":
        user       => $backupuser,
        privileges => [ 'Select_priv', 'Reload_priv', 'Lock_tables_priv', 'Show_view_priv' ],
        require    => Mysql_user["${backupuser}@localhost"],
    }

    backups::dest_dir { 'mysql': }

    database::my_sql::backup_db { 'mysql': }

    backups::dir { "mysql":
        path       => "/backups/data/mysql",
        plain_copy => true
    }

}