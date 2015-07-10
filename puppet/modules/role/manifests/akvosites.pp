
class role::akvosites {
    notice("Including role: Akvo Sites")
    include ::akvosites

    # temporary hack; we need better user management
    include users::kominski
    user { 'rumesh':
        ensure   => present,
        group    => 'www-edit',
        password => '$1$MEjCXiSx$CCc975HaVX3WDazb8Jd76.'
    }
}
