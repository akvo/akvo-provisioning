# This resource type allows you to grant a user the ability to run a particular
# command

define sudo::allow_command ( $user, $command ) {

    file { "/etc/sudoers.d/${user}__${name}":
        ensure  => present,
        mode    => '0440',
        owner   => root,
        content => template("sudo/allow_command")
    }

}
