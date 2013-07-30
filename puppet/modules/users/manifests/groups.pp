class users::groups {

    $groups = [ 'ops', 'developer' ]

    group { $groups:
        ensure => present
    }

}