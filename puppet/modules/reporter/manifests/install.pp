
class reporter::install {

    $approot = $reporter::approot

    package { 'tomcat7':
        ensure   => 'installed'
    }

    package { 'openjdk-7-jdk':
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

    file { "${approot}/install_reportserver.sh":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0700',
        source  => 'puppet:///modules/reporter/install_reportserver.sh',
        require => File[$approot]
    }

#Too big for Github...
#    file { "${approot}/RS2.2.1-5602-reportserver.zip":
#        ensure  => present,
#        owner   => 'tomcat7',
#        group   => 'tomcat7',
#        mode    => '0600',
#        source  => 'puppet:///modules/reporter/RS2.2.1-5602-reportserver.zip',
#        require => File[$approot]
#    }

    file { "${approot}/WEB-INF/classes/META-INF/persistence.xml":
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
                    File["${approot}/WEB-INF/classes/META-INF/persistence.xml"],
                    File["${approot}/rsbirt.jar.patch2"],
                    File["${approot}/rsbase.jar.patch2"],
                    File["${approot}/rssaiku.jar.patch3"],
                    Package['unzip']]
    }



}
