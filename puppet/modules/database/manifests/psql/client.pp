
define database::psql::client ($ip) {

    firewall { "200 postgresql client ${name}":
        source => $ip,
        proto  => 'tcp',
        action => accept,
        port   => 5432
    }

}