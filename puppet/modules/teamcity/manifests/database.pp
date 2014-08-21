
class teamcity::database {

    $mysql_name = hiera('teamcity_mysql_name', 'mysql')

    database::my_sql::db { 'teamcity':
        mysql_name => $mysql_name,
        password   => hiera('teamcity_database_password'),
    }

}