
class teamcity {

    Class['teamcity::package'] ->
    Class['teamcity::user'] ->
    Class['teamcity::install'] ->
    Class['teamcity::database'] ->
    Class['teamcity::configure'] ~>
    Class['teamcity::reload']

#    include teamcity::packages
#    include teamcity::user
#    include teamcity::install
#    include teamcity::configure
#    include teamcity::reload
#    include teamcity::database

    # nginx sits in front of team city
    $base_domain = hiera('base_domain')
    nginx::proxy { "ci.${base_domain}":
        proxy_url          => "http://localhost:8111",
    }

    supervisord::service { "teamcity_server":
        user      => 'teamcity',
        command   => "/opt/teamcity/TeamCity/bin/teamcity-server.sh run",
        directory => '/opt/teamcity/TeamCity',
    }
    supervisord::service { "teamcity_build_agent":
        user      => 'teamcity',
        command   => '/opt/teamcity/TeamCity/buildAgent/bin/agent.sh run',
        directory => '/opt/teamcity/TeamCity'
    }

    sudo::service_control { ["teamcity_server", "teamcity_build_agent"]:
        user         => 'teamcity',
    }

}