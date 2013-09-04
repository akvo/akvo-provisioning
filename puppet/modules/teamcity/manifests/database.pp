
class teamcity::database {

    database::my_sql::db { 'teamcity':
        password => hiera('teamcity_database_password'),
    }

}