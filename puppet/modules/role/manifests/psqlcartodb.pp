class role::psqlcartodb {
    notice("Including role: PostgreSQL DB server - CartoDB")
    include database::psql::cartodb
}
