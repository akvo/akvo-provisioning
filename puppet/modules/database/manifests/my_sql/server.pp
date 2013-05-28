class database::my_sql::server {

    class { 'mysql::server':
        config_hash => {
            'root_password'  => 'foo',  # TODO: better password :)
            'bind_address' => hiera('external_ip'),
        }
    }

    # let everyone know where we are
    @@named::service_location { "mysql":
        ip => hiera('internal_ip')
    }

    # collect any databases that services want
    Database::My_sql::Db <<| |>>

}