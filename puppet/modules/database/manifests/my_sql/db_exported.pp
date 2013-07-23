define database::my_sql::db_exported ( $password ) {

    mysql::db { $name:
        user     => $name,
        password => $password,
        host     => '%',
        grant    => ['all'],
        charset  => 'utf8',
    }

}