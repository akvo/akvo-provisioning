
# first, we run apt-get update to make sure we're getting the latest versions of packages
exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
# this ensures that the 'apt-update' Exec class is triggered before any Package classes
Exec["apt-update"] -> Package <| |>


notice("Using environment ${::environment}")


# import all of the possible configurations
import 'localdev'
