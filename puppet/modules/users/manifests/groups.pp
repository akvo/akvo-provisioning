class users::groups {

    $groups = [ 'ops', 'developer', 'test', 'reporting', 'content', 'www-edit']

    group { $groups:
        ensure => present
    }

}
