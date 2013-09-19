class database::my_sql::server {

    class { 'mysql::server':
        # for possible values in this hash, see
        # https://github.com/puppetlabs/puppetlabs-mysql/blob/master/manifests/config.pp#L5
        config_hash => {
            'root_password'  => hiera('mysql_root_password'),
            'bind_address'   => hiera('external_ip'),
            'character_set'  => 'utf8',
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
