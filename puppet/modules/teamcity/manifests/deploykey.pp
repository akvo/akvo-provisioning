define teamcity::deploykey ( $service, $environment, $key ) {

    file { "/opt/teamcity/.ssh/${service}-${environment}":
        ensure  => present,
        owner   => 'teamcity',
        group   => 'teamcity',
        require => File['/opt/teamcity/.ssh'],
        mode    => '0600',
        content => $key
    }

}