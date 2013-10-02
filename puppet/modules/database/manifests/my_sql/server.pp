class database::my_sql::server {

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
                bind_address           => hiera('external_ip'),
                default_storage_engine => 'MyISAM',
                'collation-server'     => 'utf8_unicode_ci',
                'character-set-server' => 'utf8',
                'init-connect'         => 'SET NAMES utf8'
            }
        }
    }

    # let everyone know where we are
    named::service_location { 'mysql':
        ip => hiera('internal_ip')
    }

    # collect any databases that services want
    Database::My_sql::Db_exported <<| tag == $::environment |>>

    # we want to keep our data!
    include database::my_sql::backup_support

}
