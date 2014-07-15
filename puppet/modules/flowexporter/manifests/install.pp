
class flowexporter::install {

    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    akvoapp { 'flowexporter':
        deploy_key => hiera('flowexporter-deploy_public_key')
    }

    # and some supporting packages
    package { 'openjdk-7-jre':
        ensure => 'installed'
    }

    # include the script for cleaning up old versions
    $approot = $flowexporter::params::approot
    $jardir = $flowexporter::params::jardir
    file { "${approot}/cleanup_old.sh":
        ensure  => present,
        content => template('rsr/cleanup_old.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # ensure the file structure is created
    file { [$flowexporter::workdir, $flowexporter::jardir, $flowexporter::gitconfdir]:
        ensure  => directory,
        owner   => 'flowexporter',
        mode    => '0750',
        require => File[$flowexporter::approot]
    }

}