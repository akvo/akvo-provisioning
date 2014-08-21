
define php::app (
  $app_hostnames,
  $pool_port,
  $username = undef,
  $group = undef,
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

    $app_path = "/var/akvo/${name}"

    php::pool { $name:
        poolname  => $name,
        pooluser  => $app_user,
        poolgroup => $app_group,
        poolport  => $pool_port,
        rootdir   => $app_path,
        notify    => Service['php5-fpm']
    }

    if ($config_file_contents) {
        $config_val = $config_file_contents
    } else {
        $config_val = template('php/phpapp-nginx.conf.erb')
    }

    nginx::configfile { $name:
        content => $config_val
    }

}
