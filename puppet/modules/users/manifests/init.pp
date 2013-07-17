
class users {
    include users::carl
    include users::root

    group { 'ops': }
    group { 'developer': }
}
