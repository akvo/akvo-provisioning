
# first, we run apt-get update to make sure we're getting the latest versions of packages
exec { "apt-update":
    command => "/usr/bin/apt-get update"
}
# this ensures that the 'apt-update' Exec class is triggered before any Package classes
Exec["apt-update"] -> Package <| |>


# nuke any stale firewall rules
resources { "firewall":
    purge => true
}
# nuke any unwanted cronjobs
resources { "cron":
    purge => true
}


node default {
    # the default node simply switches based on the provided list of roles
    notice("Using environment ${::environment}")

    $roles = hiera_array('roles')

    # $roles will be something like ['basic', 'management', 'monitor']
    #
    # The call to prefix will convert that to
    #  ['role::basic', 'role::management', 'role::monitor']
    #
    # Then include $role_classes includes each one of those roles.
    $role_classes = prefix($roles, 'role::')
    include $role_classes

}