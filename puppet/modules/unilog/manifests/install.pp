class unilog::install inherits unilog::params {

    # install OpenJDK Java runtime
    include javasupport

    # install lein at '/opt/leiningen' and its self-install package at $approot
    class { 'javasupport::leiningen':
        user         => $username,
        install_path => $approot,
        require      => Class["javasupport"]
    }

    # add APT repository of PostgreSQL packages - we need postgresql >= 9.4
    apt::source { 'apt.postgresql.org':
        location   => 'http://apt.postgresql.org/pub/repos/apt/',
        release    => "${::lsbdistcodename}-pgdg",
        repos      => 'main',
        key        => 'ACCC4CF8',
        key_source => 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc',
        before     => Class['Postgresql::Server::Install'] # ensure the repository is added before package installation made by external module
    }
    Apt::Source['apt.postgresql.org'] -> Package<|tag == 'postgresql'|>

    # create app's basic structure
    akvoapp { $username:
        deploy_key => hiera('unilog-deploy_public_key')
    }

}
