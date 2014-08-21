
define php::app (
  $app_hostnames,
  $username = undef,
  $group = undef,
  $wordpress = false,
  $nginx_writable = false,
  $config_file_contents = undef
) {

    include php

    if ($username) {
        $app_user = $username
    } else {
        $app_user = $name
    }

    if ($group) {
        $app_group = $group
    } else {
        $app_group = $name
    }

    akvoapp { $app_user:
    }

    ensure_resource('group', $app_group, { ensure => present })

    if ($nginx_writable) {
        exec { "${name}_add_nginx_to_${app_group}":
            command => "/usr/sbin/adduser www-data ${app_group} --quiet",
            require => Group['www-edit']
        }
    }

    $app_path = "/var/akvo/${name}"

    if ($config_file_contents) {
        $config_val = $config_file_contents
    } else {
        $config_val = template('php/phpapp-nginx.conf.erb')
    }

    nginx::configfile { $name:
        content => $config_val
    }

}
