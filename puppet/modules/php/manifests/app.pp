
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

    file { ["${app_path}/code", "${app_path}/conf"]:
        ensure  => directory,
        owner   => $app_user,
        group   => $app_group,
        mode    => '2775',
        require => File[$app_path]
    }

    if ($config_file_contents) {
        $config_val = $config_file_contents
    } else {
        $config_val = template('php/phpapp-nginx.conf.erb')
    }

    nginx::configfile { $name:
        content => $config_val
    }

    backups::dir { $name:
        path => $app_path
    }

}
