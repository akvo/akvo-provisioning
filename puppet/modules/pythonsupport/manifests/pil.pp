# adds the system libraries required to use PIL

class pythonsupport::pil {

    $required_packages = [ 'libjpeg-dev',
                           'libfreetype6',
                           'libfreetype6-dev',
                           'zlib1g-dev']

    package { $required_packages:
        ensure => 'installed'
    }

}
