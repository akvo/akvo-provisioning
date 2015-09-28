
class role::fileserver {

    notice('Including role: fileserver')

    user { 'fileserver':
        ensure => present
    }

    group { 'fileserver':
        ensure => present,
    }

    file { '/srv/fileserver':
        ensure => directory,
        owner => 'fileserver',
        group => 'fileserver',
        mode => '0775',
        require => User['fileserver'],
    }

    $base_domain = hiera('base_domain')
    $fileserver_hostname = "files.${base_domain}"
    nginx::staticsite { 'fileserver':
        hostname => $fileserver_hostname,
        rootdir  => '/srv/fileserver',
    }

    named::service_location { 'files':
        ip => hiera('external_ip')
    }

    sudo::admin_user { 'stellan': }

}
