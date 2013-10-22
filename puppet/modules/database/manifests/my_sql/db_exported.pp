define database::my_sql::db_exported (
        $password,
        $backup = true,
        $reportable = false
) {

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
        database::my_sql::backup_db { $name: }
    }

    if ($reportable) {
        mysql_grant { "reports@%/${dbname}.*":
            ensure     => present,
            user       => 'reports@%',
            table      => "${dbname}.*",
            privileges => [ 'SELECT', 'SHOW VIEW' ],
            require    => Mysql_user['reports@localhost'],
        }
    }

}