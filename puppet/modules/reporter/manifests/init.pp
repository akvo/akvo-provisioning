
class reporter {

    class { 'postgresql::server':
       ip_mask_deny_postgres_user => '0.0.0.0/32',
       ip_mask_allow_all_users => '0.0.0.0/0',
       listen_addresses => 'localhost',
    }

    package { 'tomcat7':
        ensure   => 'installed'
    }

    package { 'unzip':
        ensure   => 'installed'
    }

    package { 'postgresql':
        ensure   => 'installed'
    }

    file { '/usr/share/tomcat7/bin/setenv.sh':
        require => Package['tomcat7'],
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/reporter/setenv_tomcat.sh'
    }

    $approot = '/var/lib/tomcat7/webapps/reportserver'


    file { "${approot}/":
        ensure  => directory,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0755',
        require => Package['tomcat7']
    }

    file { "${approot}/install_reportserver.sh":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0700',
        source  => 'puppet:///modules/reporter/install_reportserver.sh',
        require => File[$approot]
    }

    file { "${approot}/RS2.2.1-5602-reportserver.zip":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0600',
        source  => 'puppet:///modules/reporter/RS2.2.1-5602-reportserver.zip',
        require => File[$approot]
    }

    file { "${approot}/persistence.xml":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0600',
        source  => 'puppet:///modules/reporter/persistence.xml',
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

    exec { "${approot}/install_reportserver.sh":
        user    => 'root',
        cwd     => "${approot}",
        creates => "${approot}/.installed",
        require => [File["${approot}/install_reportserver.sh"],
                    File["${approot}/RS2.2.1-5602-reportserver.zip"],
                    File["${approot}/persistence.xml"],
                    File["${approot}/rsbirt.jar.patch2"],
                    File["${approot}/rsbase.jar.patch2"],
                    Package['unzip']]
    }

    file { "${approot}/create_psql_db.sh":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0700',
        source  => 'puppet:///modules/reporter/create_psql_db.sh',
        require => File[$approot]
    }


#this will su to user postgres for role and db creation
#and then populate the db
    exec { "${approot}/create_psql_db.sh":
        user    => 'root',
        cwd     => "${approot}",
        creates => "${approot}/.db_created",
        require => [File["${approot}/create_psql_db.sh"],
                    Exec ["${approot}/install_reportserver.sh"]]
    }


# need proper parameters here
#    nginx::proxy { 'fileserver':
#        hostname => $fileserver_hostname,
#        rootdir  => '/srv/fileserver',
#    }


}
