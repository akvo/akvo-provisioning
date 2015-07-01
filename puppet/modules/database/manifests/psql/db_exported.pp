
define database::psql::db_exported( $password,
                                    $owner = 'postgres',
                                    $allow_createdb = false,
                                    $backup = true ) {

    postgresql::server::db { $name:
        user     => $name,
        password => $password,
        owner    => $owner,
        grant    => 'all',
        encoding => 'utf-8',
    }

    # allow user to create databases
    if $allow_createdb {
        postgresql_psql {"ALTER ROLE \"${name}\" CREATEDB":
            db      => $name,
            unless  => "SELECT rolname FROM pg_roles WHERE rolname='\"${name}\"' and rolcreatedb=true",
            require => Postgresql::Server::Db[$name]
        }
    }

    if ($backup) {
        database::psql::backup_db { $name:
            require => Postgresql::Server::Db[$name]
        }
    }
}
