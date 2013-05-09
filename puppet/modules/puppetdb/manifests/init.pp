

class puppetdb {

    # make sure the package is installed and up to date
    package { 'puppetdb':
        ensure => 'latest',
    }

    # we need nginx for proxying the puppetdb server
    include nginx

    # create an SSL proxy (puppet clients refuse to connect without SSL)
    nginx::proxy { 'testproxy':
        server_name        => "puppetdb.$basedomain",
        proxy_url          => 'http://localhost:8100',
        ssl                => true,
        password_protected => false,
    }


}