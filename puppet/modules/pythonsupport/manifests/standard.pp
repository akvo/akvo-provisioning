class pythonsupport::standard {

    debug("Installing standard python packages")

    $required_packages = ['build-essential',    # standard stuff
                          'python-dev']

    ensure_packages($required_packages)

    # we install distribute and virtualenv with pip to get a newer version than the one
    # packaged by ubuntu 12.04
    package { ['distribute', 'virtualenv']:
        ensure   => latest,
        provider => 'pip',
        require  => Package['python-pip'],
    }

}