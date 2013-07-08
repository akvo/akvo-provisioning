define database::my_sql::db ( $password ) {

    mysql::db { $name:
        user     => $name,
        password => $password,
        host     => '%',
        grant    => ['all'],
        charset  => 'utf8',
    }

}