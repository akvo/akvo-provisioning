class teamcity::service {

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

    $base_domain = hiera('base_domain')
    nginx::proxy { "ci.${base_domain}":
        proxy_url          => "http://localhost:8111",
        extra_nginx_config        => template('teamcity/nginx-extra.conf.erb'),
        extra_nginx_proxy_config  => template('teamcity/nginx-extra-proxy.conf.erb')
    }

}
