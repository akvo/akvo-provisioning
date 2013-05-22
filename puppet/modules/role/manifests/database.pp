class role::database {
    notice("Including role: database")

    include database::psql::server
}