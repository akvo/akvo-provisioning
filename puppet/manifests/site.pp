
# first, we run apt-get update to make sure we're getting the latest versions of packages
exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
# this ensures that the 'apt-update' Exec class is triggered before any Package classes
Exec["apt-update"] -> Package <| |>


notice("Using environment ${::environment}")
notice("Installing role ${::role}")


case $::environment {
    'localdev': {
        $management_server_ip = '127.0.0.1'
        $base_domain = 'localdev.akvo.org'
    }
    'live': {
        $base_domain = 'akvo.org'
    }
}



node default {
    include common

    if ( $::role == 'management' ) {
        include puppetdb
        include munin::master
    }

}