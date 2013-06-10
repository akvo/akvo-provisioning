# This class collects together common requirements for deploying and running
# a Django application.

define akvoapp::djangoapp (
        $appname = undef
) {

    if ( !$appname ) {
        $appnameval = $name
    } else {
        $appnameval = $appname
    }
    $username = $appnameval

    # we need nginx for proxying the django app
    include nginx

    # some common stuff is required
    $required_packages = ['build-essential',
                          'python-dev',
                          'python-pip']
    package { $required_packages: ensure => 'installed' }

    # we install distribute and virtualenv with pip to get a newer version than the one
    # packaged by ubuntu 12.04
    package { ['distribute', 'virtualenv']:
        ensure   => 'latest',
        provider => 'pip',
    }

    # we also need to create the virtualenv
    $approot = "/apps/${appnameval}/venv"
    exec { "make_venv_${appnameval}":
        command => "/usr/local/bin/virtualenv ${approot}",
        creates => $approot,
        user    => $username,
        cwd     => "/apps/$username",
        require => [User[$username], File["/apps/${username}"], Package['virtualenv']],
    }

}