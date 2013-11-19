
define php::app (
  $app_hostnames,
  $username = undef,
  $group = undef,
  $wordpress = false,
  $nginx_writable = false,
  $config_file_contents = undef
) {

    include php
    include akvoapp

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

    user { $app_user:
        ensure => present,
        home   => $app_path,
        shell  => '/bin/bash',
        groups => $app_group
    }

    ensure_resource('group', $app_group, { ensure => present })

    if ($nginx_writable) {
        exec { "${name}_add_nginx_to_${app_group}":
            command => "/usr/sbin/adduser www-data ${app_group} --quiet",
            require => Group['www-edit']
        }
    }

    $app_path = "/var/akvo/${name}"

    file { [$app_path, "${app_path}/code"]:
        ensure  => directory,
        owner   => $app_user,
        group   => $app_group,
        mode    => '2775',
        require => File['/var/akvo']
    }

    file { "${app_path}/logs":
        ensure  => directory,
        owner   => 'www-data',
        group   => $app_group,
        mode    => '0755',
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
