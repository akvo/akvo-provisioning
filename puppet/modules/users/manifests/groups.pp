class users::groups {

    $groups = [ 'ops', 'developer', 'test' ]

    group { $groups:
        ensure => present
    }

}