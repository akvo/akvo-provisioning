# note: this is called psql to avoid a conflict with the installed
# puppet module, 'postgresql'

class database::psql::server {

    $psql_name = hiera('psql_name')
    $base_domain = hiera('base_domain')
    $psql_host = "${psql_name}.${base_domain}"

    $external_ip = hiera('external_ip')

    class { 'postgresql::server':
       ip_mask_deny_postgres_user => '0.0.0.0/32',
       ip_mask_allow_all_users => '0.0.0.0/0',
       listen_addresses => $external_ip,
    }

    # let everyone know where we are
    named::service_location { "${psql_name}":
        ip => hiera('external_ip')
    }

    # collect any databases that services want
    Database::Psql::Db_exported <<| tag == "psql-db-${psql_host}" |>>

    # allow people to connect
    Database::Psql::Client <<| tag == "psql-client-${psql_host}" |>>

    # we want to keep our data!
    include database::psql::backup_support

}