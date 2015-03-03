class role::psqldb {
    notice("Including role: PostgreSQL DB server")
    include database::psql::server
}