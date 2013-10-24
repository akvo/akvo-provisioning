class users::groups {

    $groups = [ 'ops', 'developer', 'test', 'reporting', 'content' ]

    group { $groups:
        ensure => present
    }

}
