define database::my_sql::db ( $password, $reportable = false ) {

    @@database::my_sql::db_exported{ $name:
        password   => $password,
        reportable => $reportable,
        tag        => $::environment
    }

}