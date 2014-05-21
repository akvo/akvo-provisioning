define database::my_sql::db ( $password, $reportable = false, $include_fw_rule = true ) {

    @@database::my_sql::db_exported { $name:
        password   => $password,
        reportable => $reportable,
        tag        => $::environment
    }

    if ($include_fw_rule) {
        @@database::my_sql::client { $name:
            ip  => hiera('external_ip'),
            tag => $::environment
        }
    }

}