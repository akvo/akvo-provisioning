class role::rsr {
    notice("Including role: RSR")

    class { '::rsr':
        develop_mode => hiera('rsr_development')
    }

}