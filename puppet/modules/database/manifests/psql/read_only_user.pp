define database::psql::read_only_user {

    $dbname = $name

    $user = "${name}_read_only"
    $password = hiera('psql_read_only_password')

    $db_grant = "GRANT CONNECT ON DATABASE \"${dbname}\" TO \"${user}\";"
    $table_grant = "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"${user}\";"
    $seq_grant = "GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO \"${user}\";"
    $schema_table_grant = "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"${user}\";"
    $schema_seq_grant = "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO \"${user}\";"

    postgresql::server::role { $user:
        password_hash => postgresql_password($user, $password),
    }->
    postgresql_psql { "${dbname}-ro-db-grant":
        command   => $db_grant,
        db        => $dbname,
        require   => Class['postgresql::server'],
    }->
    postgresql_psql { "${dbname}-ro-table-grant":
        command   => $table_grant,
        db        => $dbname,
        require   => Class['postgresql::server']
    }->
    postgresql_psql { "${dbname}-ro-seq-grant":
        command   => $seq_grant,
        db        => $dbname,
        require   => Class['postgresql::server']
    }->
    postgresql_psql { "${dbname}-ro-schema-table-grant":
        command   => $schema_table_grant,
        db        => $dbname,
        require   => Class['postgresql::server']
    }->
    postgresql_psql { "${dbname}-ro-schema-seq-grant":
        command   => $schema_seq_grant,
        db        => $dbname,
        require   => Class['postgresql::server']
    }
}