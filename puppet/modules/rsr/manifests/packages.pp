class rsr::packages {

    # some common stuff is required
    $required_packages = ['build-essential',
                          'python-dev']
    package { $required_packages: ensure => 'installed' }

    # we install distribute and virtualenv with pip to get a newer version than the one
    # packaged by ubuntu 12.04
    package { ['distribute', 'virtualenv']:
        ensure   => 'latest',
        provider => 'pip',
        require  => Package['python-pip'],
    }
}