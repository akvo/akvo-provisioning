class users::groups {

    $groups = [ 'ops', 'developer', 'test', 'reporting', 'content', 'www-edit']

    group { $groups:
        ensure => present
    }

    sudo::allow_as_user { 'devs_can_rsr':
        group => 'developer',
        as_user => 'rsr'
    }

    sudo::allow_as_user { 'devs_can_unilog':
        group => 'developer',
        as_user => 'unilog'
    }

}
