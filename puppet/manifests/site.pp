
# first, we run apt-get update to make sure we're getting the latest versions of packages
exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
# this ensures that the 'apt-update' Exec class is triggered before any Package classes
Exec["apt-update"] -> Package <| |>



node default {
    # the default node simply switches based on the provided list of roles

    notice("Using environment ${::environment}")

    include common

    $roles = hiera_array('roles')

    if 'management' in $roles { import 'management' }
    if 'monitor' in $roles { import 'monitor' }

}