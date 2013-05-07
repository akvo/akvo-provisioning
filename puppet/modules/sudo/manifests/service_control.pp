
# This resource type allows you to grant a user the ability to start, stop
# and restart a supervisord process by giving them sudo access to only the
# relevant commands

define sudo::service_control ( $user, $service_name_arg = undef ) {

    $service_name = firstof($service_name_arg, $name)

    file { "/etc/sudoers.d/${user}__${service_name}_control":
        ensure  => present,
        mode    => '0440',
        owner   => 'root',
        content => template("sudo/service_control"),
    }
}