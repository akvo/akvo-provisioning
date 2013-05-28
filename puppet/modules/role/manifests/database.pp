class role::database {
    notice("Including role: database")

    include database::psql::server
    include database::my_sql::server
}