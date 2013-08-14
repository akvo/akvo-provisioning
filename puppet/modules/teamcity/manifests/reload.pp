class teamcity::reload {
    supervisord::restart { 'teamcity_server': }
}