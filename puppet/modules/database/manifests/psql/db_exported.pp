
define database::psql::db_exported( $password, $backup = true ) {

    postgresql::server::db { $name:
        user          => $name,
        password      => $password,
        grant         => 'all',
    }

    if ($backup) {
        database::psql::backup_db { $name: }
    }
}