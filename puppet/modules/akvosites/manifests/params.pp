class akvosites::params {

    $mysql_name = hiera('akvosites_database_mysql_name', 'mysql')
    $db_password = hiera('akvosites_database_password')

    $base_domain = hiera('base_domain')
    $default_domain = hiera('akvosites_default_domain', "akvosites.${base_domain}")
    $akvosites_hostnames = hiera('akvosites_hostnames')
    $all_hostnames = concat($akvosites_hostnames, [$default_domain])
    $app_path = '/var/akvo/akvosites'
    $pool_port = 9020
    $pool_processes = 16

    $db_host = "${mysql_name}.${base_domain}"
    $db_table_prefix = hiera('akvosites_db_table_prefix', 'wi1_')

}
