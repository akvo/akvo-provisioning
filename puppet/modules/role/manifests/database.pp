class role::database {
    notice("Including role: database")

    # no need for psql just yet

    include database::my_sql::server

    if (hiera('include_postgres', false)) {
        include database::psql::server
    }
}