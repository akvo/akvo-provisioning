
class reporter::config {

    $port = $reporter::port
    $db_name = $reporter::db_name
    $db_username = $reporter::db_username
    $db_password = $reporter::db_password

    $base_domain = hiera('base_domain')
    $url_prefix = "http://reporter.${base_domain}"

    $approot = $reporter::approot

    file { "${approot}/create_psql_db.sh":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0700',
        source  => 'puppet:///modules/reporter/create_psql_db.sh',
        require => File[$approot]
    }

    database::psql::db { $db_name:
        psql_name => $reporter::psql_name,
        password  => $db_password
    }


#this will su to user postgres for role and db creation
#and then populate the db
    exec { "${approot}/create_psql_db.sh":
        user    => 'root',
        cwd     => "${approot}",
        creates => "${approot}/.db_created",
        require => File["${approot}/create_psql_db.sh"],
    }


#    named::service_location { 'reporter':
#        ip => hiera('external_ip')
#    }

    nginx::proxy { "reporting.${base_domain}":
        proxy_url => "http://localhost:${port}",
        htpasswd => false
    }

}