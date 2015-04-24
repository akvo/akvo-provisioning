class unilog::install inherits unilog::params {

    # install OpenJDK Java runtime
    include javasupport

    # install lein at '/opt/leiningen' and its self-install package at $approot
    class { 'javasupport::leiningen':
        user         => $username,
        install_path => $approot,
        require      => Class["javasupport"]
    }

    # create app's basic structure
    akvoapp { $username:
        deploy_key => hiera('unilog-deploy_public_key')
    }

}
