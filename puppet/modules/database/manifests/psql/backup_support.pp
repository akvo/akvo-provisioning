
class database::psql::backup_support {

    $backupuser = 'backup'
    $backuppassword = hiera('psql_backup_password')

    postgresql::server::role { $backupuser:
        password_hash => postgresql_password($backupuser, $backuppassword),
    }

    backups::dest_dir { 'psql': }

    backups::dir { "psql":
        path       => "/backups/data/psql",
        plain_copy => true
    }

}