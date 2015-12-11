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

    # add unilog user private key
    file { "${approot}/.ssh/id_rsa":
        ensure  => present,
        owner   => 'backup',
        group   => 'backup',
        mode    => '0600',
        content => hiera('unilog_private_key'),
        require => Akvoapp[$username]
    }

    file { [ "${approot}/versions", "${approot}/config", "${approot}/tmp" ]:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => [ User[$username], Group[$username], File[$approot] ],
    }

    # include the script for initializing the database for each FLOW server configuration
    file { "${approot}/initialize_db.sh":
        ensure  => present,
        content => template('unilog/initialize_db.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => [ User[$username], Group[$username], File[$approot] ]
    }

    # include the script for downloading and creating an app
    file { "${approot}/make_app.sh":
        ensure  => present,
        content => template('unilog/make_app.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => [ User[$username], Group[$username], File[$approot] ]
    }

    # include the script for switching the app
    file { "${approot}/make_current.sh":
        ensure  => present,
        content => template('unilog/make_current.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => [ User[$username], Group[$username], File[$approot] ]
    }

}
