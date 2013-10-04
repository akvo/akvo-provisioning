
class homepage {

    include akvoapp

    $wwwroot = '/var/akvo/homepage'

    user { 'homepage':
        ensure => present,
        home   => $wwwroot,
        shell  => '/bin/bash'
        group  => 'homepage'
    }

    group { 'homepage':
        ensure => present
    }

    file { $wwwroot:
        ensure  => directory,
        owner   => 'homepage',
        group   => 'www-edit',
        mode    => '0775',
        require => File['/var/akvo']
    }

    backups::dir { "homepage":
        path => $wwwroot
    }

}