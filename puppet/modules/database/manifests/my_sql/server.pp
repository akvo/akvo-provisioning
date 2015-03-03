class database::my_sql::server {

    $mysql_name = hiera('mysql_name')
    $base_domain = hiera('base_domain')
    $mysql_host = "${mysql_name}.${base_domain}"

    class { 'mysql::server':
        root_password    => hiera('mysql_root_password'),
        override_options => {
            # for possible values in this hash, see
            # https://github.com/puppetlabs/puppetlabs-mysql/blob/master/manifests/init.pp
            client => {
                'default-character-set' => 'utf8'
            },
            mysql => {
                'default-character-set' => 'utf8'
            },
            mysqld => {
                bind_address           => '0.0.0.0',
                default_storage_engine => 'MyISAM',
                'collation-server'     => 'utf8_unicode_ci',
                'character-set-server' => 'utf8',
                'init-connect'         => 'SET NAMES utf8'
            }
        }
    }

    # let everyone know where we are
    named::service_location { $mysql_name:
        ip => hiera('internal_ip')
    }

    # collect any databases that services want
    Database::My_sql::Db_exported <<| tag == "mysql-db-${mysql_host}" |>>

    # and allow access to clients
    Database::My_sql::Client <<| tag == "mysql-client-${mysql_host}" |>>

    # we want to keep our data!
    include database::my_sql::backup_support

    # and people want to see it
    include database::my_sql::reports_support

}
