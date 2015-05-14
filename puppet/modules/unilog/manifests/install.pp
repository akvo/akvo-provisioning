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

    file { [ "${approot}/versions", "${approot}/config" ]:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => [ User[$username], Group[$username], File[$approot] ],
    }

    # config file
    file { "${approot}/config/config.edn":
        ensure   => present,
        owner    => $username,
        group    => $username,
        mode     => '0440',
        content  => template('unilog/config.edn.erb'),
        require  => File["${approot}/config"],
        notify   => Class['supervisord::update']
    }

}
