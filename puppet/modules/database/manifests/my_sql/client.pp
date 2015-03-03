
define database::my_sql::client($ip) {

    firewall { "200 mysql client ${name}":
        source => $ip,
        proto  => 'tcp',
        action => accept,
        port   => 3306
    }

}