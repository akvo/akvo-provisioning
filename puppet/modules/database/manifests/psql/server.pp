# note: this is called psql to avoid a conflict with the installed
# puppet module, 'postgresql'

class database::psql::server {

    $psql_name = hiera('psql_name')
    $base_domain = hiera('base_domain')
    $psql_host = "${psql_name}.${base_domain}"
    $psql_version = hiera('psql_version', '9.1')

    $external_ip = hiera('external_ip')

    Apt::Source['apt.postgresql.org'] -> Package<|tag == 'postgresql'|>

    # add APT repository of PostgreSQL packages - we may need postgresql >= 9.1
    apt::source { 'apt.postgresql.org':
        location   => 'http://apt.postgresql.org/pub/repos/apt/',
        release    => "${::lsbdistcodename}-pgdg",
        repos      => 'main',
        key        => 'ACCC4CF8',
        key_source => 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc',
    } ->
    # set PostgreSQL global parameters
    class {'postgresql::globals':
        version             => $psql_version,
        manage_package_repo => false,
        encoding            => 'UTF8',
        locale              => 'C'
    }->
    # create the PostgreSQL server
    class { 'postgresql::server':
       ip_mask_deny_postgres_user => '0.0.0.0/32',
       ip_mask_allow_all_users => '0.0.0.0/0',
       listen_addresses => $external_ip,
    }

    # let everyone know where we are
    named::service_location { ["${psql_name}", "*"]:
        ip => hiera('external_ip')
    }

    # collect any databases that services want
    Database::Psql::Db_exported <<| tag == "psql-db-${psql_host}" |>>

    # allow people to connect
    Database::Psql::Client <<| tag == "psql-client-${psql_host}" |>>

    # we want to keep our data!
    include database::psql::backup_support

}
