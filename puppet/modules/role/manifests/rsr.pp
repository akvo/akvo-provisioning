class role::rsr {
    notice("Including role: RSR")

    $develop_mode = str2bool(hiera('rsr_development'))
    class { '::rsr':
        develop_mode => $develop_mode
    }

}