
define database::psql::db_exported( $password, $backup = true ) {

    postgresql::server::db { $name:
        user          => $name,
        password      => $password,
        grant         => 'all',
        encoding      => 'utf-8',
    }

    if ($backup) {
        database::psql::backup_db { $name:
            require => Postgresql::Server::Db[$name]
        }
    }
}
