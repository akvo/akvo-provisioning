define database::my_sql::db ( $password ) {

    @@database::my_sql::db_exported{ $name:
        password => $password,
        tag      => $::environment
    }

}