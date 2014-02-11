
class role::akvosites {
    notice("Including role: Akvo Sites")
    include ::akvosites

    # temporary hack; we need better user management
    include users::kominski
}