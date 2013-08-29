define database::my_sql::db_exported ( $password, $backup = true ) {
    $dbname = $name
    $username = $dbname

    mysql::db { $dbname:
        user     => $username,
        password => $password,
        host     => '%',
        grant    => ['all'],
        charset  => 'utf8',
    }

    if ($backup) {
        database::my_sql::backup_db { $name }
    }

}