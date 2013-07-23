define database::psql::db ( $password ) {

    notice("postgresql database ${name}")

    @@database::psql::db_exported { $name:
        password => $password,
        tag      => $::environment
    }

}