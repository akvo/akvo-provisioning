
class reporter::config {

    $qport = $reporter::port
#    $db_qname = $reporter::db_name
#    $db_qusername = $reporter::db_username

    $base_domain = hiera('base_domain')
    $url_prefix = "http://reporter.${base_domain}"

    $approot = $reporter::approot

    file { "${approot}/create_psql_db.sh":
        ensure  => present,
        owner   => 'tomcat7',
        group   => 'tomcat7',
        mode    => '0755',
        source  => 'puppet:///modules/reporter/create_psql_db.sh',
        require => File[$approot]
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
        proxy_url => "http://localhost:${qport}",
        htpasswd => false
    }

}