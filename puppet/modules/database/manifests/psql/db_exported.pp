
define psql::db_exported( $password ) {

    postgresql::db { $name:
        user          => $name,
        password      => $password,
        grant         => 'all',
    }
}