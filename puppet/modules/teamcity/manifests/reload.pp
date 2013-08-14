class teamcity::reload {
    supervisord::restart { ['teamcity_server', 'teamcity_build_agent']: }
}