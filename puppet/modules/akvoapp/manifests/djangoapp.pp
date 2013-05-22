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

    # some common stuff is required
    $required_packages = ['build-essential',
                          'python-dev',
                          'python-virtualenv',
                          'python-pip']

    package { $required_packages: ensure => 'installed' }

    # we also need to create the virtualenv
    $approot = "/apps/${appnameval}/venv"
    exec { "make_venv_${appnameval}":
        command => "/usr/bin/virtualenv ${approot}",
        creates => $approot,
        user    => $username,
        cwd     => "/apps/$username",
        require => [User[$username], File["/apps/${username}"], Package['python-virtualenv']],
    }

}