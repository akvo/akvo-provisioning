# == Class: database::psql::cartodb
#
# This class configures a PostgreSQL server and installs all what's neede by CartoDB
#
class database::psql::cartodb {

    $psql_cartodb_version = hiera('psql_cartodb_ext_version', '0.7.3')
    $psql_version = hiera('psql_version', '9.3')
    $psql_password = hiera('psql_password', 'password')
    $data_dir = hiera('psql_data_directory', undef)

    # grant all permissions needed to 'postgres' user
    postgresql::server::role { 'postgres':
        createdb      => true,
        superuser     => true,
        replication   => true,
        createrole    => true,
        password_hash => postgresql_password('postgres', $psql_password),
    }

    # add postgres user to puppet group
    # needed to store pg_data into /puppet
    user { 'postgres':
        groups => ['puppet']
    }

    # set PostgreSQL global parameters
    class {'postgresql::globals':
        version              => $psql_version,
        manage_package_repo  => true,
        pg_hba_conf_defaults => false,
        encoding             => 'UTF8',
        locale               => 'C',
        datadir              => $data_dir,
    }->

    # create the PostgreSQL server
    class { 'postgresql::server':
       ip_mask_deny_postgres_user => '0.0.0.0/32',
       ip_mask_allow_all_users    => '0.0.0.0/0',
       listen_addresses           => hiera('external_ip')
    }

    # install packages required by CartoDB postgres
    package { 'postgis':
        # specific version - otherwise, on ubuntu trusty, it installs postgres 9.5
        ensure => '2.1.2+dfsg-2'
    }->
    package { [ "postgresql-server-dev-${psql_version}",
                "libpq-dev",
                "libxml2-dev",
                "liblwgeom-2.1.8",
                "postgresql-plpython-${psql_version}",
                "postgresql-${psql_version}-postgis-2.1",
                "postgresql-${psql_version}-postgis-2.1-scripts" ]:
        ensure  => installed,
        require => Apt::Source['apt.postgresql.org']
    }->

    # script to install schema_triggers and CartoDB extension
    file { '/usr/local/bin/cartodb.sh':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0700',
        content => template('database/psql/cartodb.sh.erb'),
        notify  => Exec['cartodb_install']
    }->

    exec { 'cartodb_install':
        command     => '/usr/local/bin/cartodb.sh',
        refreshonly => true,
        require     => Service["postgresql"]
    }->

    # initialize template postgis database
    postgresql::server::database { 'template_postgis':
        istemplate => true,
        owner      => 'postgres',
        encoding   => 'utf-8',
    }

    # install postgis extensions
    # 'postgis' is required by 'postgis_topology'
    postgresql::server::extension { 'postgis': 
        database => 'template_postgis',
        require  => Postgresql::Server::Database['template_postgis']
    }->
    postgresql::server::extension { 'postgis_topology': 
        database => 'template_postgis',
    }

    # only allow connections from specified clients
    # doesn't apply to localdev environments
    if $::environment != "localdev" {
        $firewall_defaults = {
            proto => 'tcp',
            action => 'accept',
            port => $postgres_port
        }
        create_resources(firewall, $postgres_clients, $firewall_defaults)
    }
    else {
        firewall { "200 postgresql":
            proto  => 'tcp',
            action => accept,
            port   => 5432
        }
    }

    # create needed access rules on pg_hba.conf
    postgresql::server::pg_hba_rule { 'allow local connections':
        description => "Open up PostgreSQL for local connections",
        type        => 'local',
        database    => 'all',
        address     => '',
        user        => 'all',
        auth_method => 'trust',
    }

    # cannot find a better way to allow cartodb users to access its database
    # 'user' doesn't accept regular expressions
    # luckily we only allow connections from specified clients/hosts
    postgresql::server::pg_hba_rule { 'allow host connection':
        description => "Open up PostgreSQL for host connections",
        type        => 'host',
        database    => 'all',
        address     => '0.0.0.0/0',
        user        => 'all',
        auth_method => 'trust',
    }

}
