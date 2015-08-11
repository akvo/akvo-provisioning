class keycloak::install inherits keycloak::params {

    $approot = $keycloak::approot
    $appdir = $keycloak::appdir
    $db_name = $keycloak::db_name
    $db_host = $keycloak::db_host
    $db_username = $keycloak::db_username
    $db_password = $keycloak::db_password
    $kc_release = $keycloak::kc_release
    $psql_dir = $keycloak::psql_dir

    package { 'openjdk-7-jdk':
        ensure => 'installed'
    }

    package { 'postgresql-client':
        ensure => 'installed'
    }

    user { 'keycloak':
        ensure => present,
        shell  => '/bin/bash',
        home   => '/opt/keycloak',
    }

    group { 'keycloak':
        ensure => present,
    }

    file { "${approot}/":
        ensure  => directory,
        owner   => 'keycloak',
        group   => 'keycloak',
        mode    => '0700',
        require => User['keycloak']
    }

    file { "${approot}/install_keycloak.sh":
        ensure  => present,
        owner   => 'keycloak',
        group   => 'keycloak',
        mode    => '0700',
        content => template('keycloak/install_keycloak.sh.erb'),
        require => File[$approot]
    }

    exec { "${approot}/install_keycloak.sh":
        user    => 'keycloak',
        cwd     => "${approot}",
        creates => "${approot}/.installed-$kc_release",
        require => [File["${approot}/install_keycloak.sh"],
                    Package['postgresql-client']]
    }

    file { "${psql_dir}/module.xml":
        require => Exec["${approot}/install_keycloak.sh"],
        ensure  => present,
        owner   => 'keycloak',
        group   => 'keycloak',
        mode    => '0755',
        content => template('keycloak/module.xml.erb')
    }

    database::psql::db { $db_name:
        psql_name => $keycloak::psql_name,
        password  => $db_password
    }

}
