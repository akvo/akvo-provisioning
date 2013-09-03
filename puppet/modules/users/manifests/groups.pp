class users::groups {

    $groups = [ 'ops', 'developer', 'test', 'www-edit' ]

    group { $groups:
        ensure => present
    }

}
