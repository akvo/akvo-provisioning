class pythonsupport::standard {

    debug("Installing standard python packages")

    $required_packages = ['build-essential',    # standard stuff
                          'python-dev']

    ensure_packages($required_packages)

    # we install distribute and virtualenv with pip to get a newer version than the one
    # packaged by ubuntu 12.04
    package { 'distribute':
        ensure   => latest,
        provider => 'pip',
        require  => Package['python-pip'],
    }

    # virtualenv 1.11 is broken, so we make sure we don't install it:
    # see https://github.com/pypa/virtualenv/issues/524
    package { 'virtualenv':
        ensure => '1.10.1',
        provider => 'pip',
        require => Package['python-pip']
    }

}