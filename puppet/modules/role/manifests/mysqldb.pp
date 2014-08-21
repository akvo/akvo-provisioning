class role::mysqldb {
    notice("Including role: MySQL DB server")
    include database::my_sql::server
}