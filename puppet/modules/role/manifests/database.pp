class role::database {
    notice("Including role: database")

    # no need for psql just yet
    # include database::psql::server

    include database::my_sql::server
}