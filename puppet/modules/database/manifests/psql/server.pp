# note: this is called psql to avoid a conflict with the installed
# puppet module, 'postgresql'

class database::psql::server {

    $external_ip = hiera('external_ip')

    class { 'postgresql::server':
       ip_mask_deny_postgres_user => '0.0.0.0/32',
       ip_mask_allow_all_users => '0.0.0.0/0',
       listen_addresses => $external_ip,
    }

    # let everyone know where we are
    named::service_location { "psql":
        ip => hiera('external_ip')
    }

    # collect any databases that services want
    Database::Psql::Db_exported <<| tag == $::environment |>>

    # allow people to connect
    Database::Psql::Client <<| tag == $::environment |>>

    # we want to keep our data!
    include database::psql::backup_support

}