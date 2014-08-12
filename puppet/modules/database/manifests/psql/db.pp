define database::psql::db ($psql_name, $password, $include_fw_rule = true ) {

    $base_domain = hiera('base_domain')
    $psql_host = "${psql_name}.${base_domain}"

    notice("postgresql database ${name} at ${psql_name}")

    @@database::psql::db_exported { $name:
        password => $password,
        tag        => "psql-db-${psql_host}"
    }

    if ($include_fw_rule) {
        @@database::psql::client { $name:
            ip  => hiera('external_ip'),
            tag        => "psql-client-${psql_host}"
        }
    }
}