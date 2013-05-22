# note: this is called psql to avoid a conflict with the installed
# puppet module, 'postgresql'

class database::psql::server {

    class { 'postgresql::server':
        config_hash => {
            'ip_mask_deny_postgres_user' => '0.0.0.0/32',
            'ip_mask_allow_all_users' => '0.0.0.0/0',
            'listen_addresses' => hiera('internal_ip'),
        },
    }

    # let everyone know where we are
    @@named::service_location { "psql":
        ip => hiera('internal_ip')
    }

    # collect any databases that services want
    Database::Psql::Db <<| |>>

}