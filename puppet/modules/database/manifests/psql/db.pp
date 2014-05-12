define database::psql::db ( $password, $include_fw_rule = true ) {

    notice("postgresql database ${name}")

    @@database::psql::db_exported { $name:
        password => $password,
        tag      => $::environment
    }

    if ($include_fw_rule) {
        @@database::psql::client { $name:
            ip  => hiera('external_ip'),
            tag => $::environment
        }
    }
}