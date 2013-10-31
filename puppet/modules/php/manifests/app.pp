
define php::app (
  $app_hostnames,
  $username = undef,
  $group = undef,
  $wordpress = false
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

    $app_path = "/var/akvo/${name}"

    file { [$app_path, "${app_path}/code"]:
        ensure  => directory,
        owner   => $app_user,
        group   => $app_group,
        mode    => '0775',
        require => File['/var/akvo']
    }

    file { "${app_path}/logs":
        ensure  => directory,
        owner   => 'www-data',
        group   => $app_group,
        mode    => '0755',
        require => File[$app_path]
    }

    nginx::configfile { $name:
        content => template('php/phpapp-nginx.conf.erb')
    }

    backups::dir { $name:
        path => $app_path
    }

}