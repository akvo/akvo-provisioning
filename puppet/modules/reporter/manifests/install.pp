
class reporter::install {

    $approot = $reporter::approot
    $db_name = $reporter::db_name
    $db_host = $reporter::db_host
    $db_username = $reporter::db_username
    $db_password = $reporter::db_password

    package { 'tomcat7':
        ensure   => 'installed'
    }

    package { 'openjdk-7-jdk':
        ensure   => 'installed'
    }

    package { 'postgresql-client':
        ensure   => 'installed'
    }

    package { 'unzip':
        ensure   => 'installed'
    }

    file { '/usr/share/tomcat7/bin/setenv.sh':
        require => [Package['tomcat7'],Package['openjdk-7-jdk']],
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/reporter/setenv_tomcat.sh'
    }


    file { "${approot}/":
        ensure  => directory,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0755',
        require => Package['tomcat7']
    }

#tomcat needs to be restricted from serving around the proxy
    file { "${approot}/conf/server.xml":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0700',
        source  => 'puppet:///modules/reporter/server.xml',
        require => File[$approot]
    }

    file { "${approot}/install_reportserver.sh":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0700',
        source  => 'puppet:///modules/reporter/install_reportserver.sh',
        require => File[$approot]
    }

    file { "${approot}/rsbirt.jar.patch2":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0644',
        source  => 'puppet:///modules/reporter/rsbirt.jar.patch2',
        require => File[$approot]
    }

    file { "${approot}/rsbase.jar.patch2":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0644',
        source  => 'puppet:///modules/reporter/rsbase.jar.patch2',
        require => File[$approot]
    }

    file { "${approot}/rssaiku.jar.patch3":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0644',
        source  => 'puppet:///modules/reporter/rssaiku.jar.patch3',
        require => File[$approot]
    }

    exec { "${approot}/install_reportserver.sh":
        user    => 'root',
        cwd     => "${approot}",
        creates => "${approot}/.installed",
        require => [File["${approot}/install_reportserver.sh"],
                    File["${approot}/rsbirt.jar.patch2"],
                    File["${approot}/rsbase.jar.patch2"],
                    File["${approot}/rssaiku.jar.patch3"],
                    Package['unzip'],
                    Package['postgresql-client']]
    }


    file { "${approot}/WEB-INF/classes/META-INF/persistence.xml":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0600',
        content  => template('reporter/persistence.xml.erb'),
        require => [File[$approot], Exec["${approot}/install_reportserver.sh"]]
    }

    database::psql::db { $db_name:
        psql_name => $reporter::psql_name,
        password  => $db_password
    }


}
