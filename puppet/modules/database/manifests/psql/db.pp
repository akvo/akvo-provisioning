define database::psql::db ($psql_name, $password,
                           $owner = 'postgres',
                           $include_fw_rule = true,
                           $reportable = false,
                           $allow_createdb = false,
                           $add_read_only = false) {

    $base_domain = hiera('base_domain')
    $psql_host = "${psql_name}.${base_domain}"

    notice("postgresql database ${name} at ${psql_name}")

    @@database::psql::db_exported { $name:
        owner          => $owner,
        password       => $password,
        allow_createdb => $allow_createdb,
        add_read_only  => $add_read_only,
        tag            => "psql-db-${psql_host}"
    }

    if ($include_fw_rule) {
        @@database::psql::client { $name:
            ip  => hiera('external_ip'),
            tag => "psql-client-${psql_host}"
        }
    }
}
