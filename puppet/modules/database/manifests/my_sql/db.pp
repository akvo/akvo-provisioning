define database::my_sql::db ( $mysql_name, $password, $reportable = false, $include_fw_rule = true ) {

    $base_domain = hiera('base_domain')
    $mysql_host = "${mysql_name}.${base_domain}"

    @@database::my_sql::db_exported { $name:
        password   => $password,
        reportable => $reportable,
        tag        => "mysql-db-${mysql_host}"
    }

    if ($include_fw_rule) {
        @@database::my_sql::client { $name:
            ip  => hiera('external_ip'),
            tag => "mysql-client-${mysql_host}"
        }
    }

}