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


    # there is no easy way to specify multiple hosts for the same user/DB, and we need both '%' access
    # (for applications on other services) and 'localhost' access (for people creating ssh tunnels to
    # access the DBs)
    mysql_grant { "${username}@localhost/${dbname}.*":
        ensure     => present,
        user       => "${username}@localhost",
        table      => "${dbname}.*",
        privileges => ["ALL"],
        require    => Mysql::Db[$dbname]
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
            require    => Mysql_user['reports@%'],
        }
    }

}