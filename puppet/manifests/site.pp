
# first, we run apt-get update to make sure we're getting the latest versions of packages
exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
# this ensures that the 'apt-update' Exec class is triggered before any Package classes
Exec["apt-update"] -> Package <| |>


notice("Using environment ${::environment}")
notice("Installing role ${::role}")


$base_domain = hiera('base_domain')
$management_server_ip = hiera('management_server_ip')
$roles = hiera_array('roles')



node default {
    include common

    if 'management' in $::roles {
        include puppetdb
        include munin::master
    }

}