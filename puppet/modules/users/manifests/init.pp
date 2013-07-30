
class users {
    include users::groups

    include users::carl
    include users::oliver
    include users::root

    Class['Users::Groups'] -> Users::Basic<||>
}
