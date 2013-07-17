
class users {
    include users::carl
    include users::root

    group { ['developer', 'ops']:
        ensure => present
    }
}
