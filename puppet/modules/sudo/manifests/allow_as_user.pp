# This resource type allows you to grant a group the ability to become or
# run commands as a different user. This is useful to allow, eg, all developers
# to run as the 'rsr' user.

define sudo::allow_as_user ( $group, $as_user ) {

    file { "/etc/sudoers.d/allow_${group}_as_user_${as_user}":
        ensure  => present,
        mode    => '0440',
        owner   => root,
        content => template("sudo/allow_as_user")
    }

}
