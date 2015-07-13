
class keycloak::install {

    $approot = $keycloak::approot
    $tomcatconf = $keycloak::tomcatconf
    $db_name = $keycloak::db_name
    $db_host = $keycloak::db_host
    $db_username = $keycloak::db_username
    $db_password = $keycloak::db_password

    package { 'openjdk-7-jdk':
        ensure   => 'installed'
    }

    package { 'postgresql-client':
        ensure   => 'installed'
    }

    user { 'keycloak':
        ensure => present,
        shell  => '/bin/bash',
        home   => '/opt/keycloak',
    }

    group { 'keycloak':
        ensure => present,
    }

#    file { '/usr/share/tomcat7/bin/setenv.sh':
#        require => [Package['tomcat7'],Package['openjdk-7-jdk']],
#        ensure  => present,
#        owner   => 'root',
#        group   => 'root',
#        mode    => '0755',
#        source  => 'puppet:///modules/reporter/setenv_tomcat.sh'
#    }


#700?
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
        source  => 'puppet:///modules/keycloak/install_keycloak.sh',
        require => File[$approot]
    }


    exec { "${approot}/install_keycloak.sh":
        user    => 'keycloak',
        cwd     => "${approot}",
        creates => "${approot}/.installed",
        require => [File["${approot}/install_keycloak.sh"],
                    Package['postgresql-client']]
    }


#    file { "${approot}/WEB-INF/classes/persistence.properties":
#        ensure  => present,
#        owner   => 'keycloak',
#        group   => 'keycloak',
#        mode    => '0600',
#        content  => template('reporter/persistence.properties.erb'),
#        require => [File[$approot], Exec["${approot}/install_reportserver.sh"]]
#    }


    database::psql::db { $db_name:
        psql_name => $keycloak::psql_name,
        password  => $db_password
    }



}
