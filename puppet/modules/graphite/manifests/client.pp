
define graphite::client ($ip) {

    firewall { "200 graphite client ${name}":
        port   => 2003,
        proto  => 'tcp',
        action => accept,
        source => $ip
    }

}