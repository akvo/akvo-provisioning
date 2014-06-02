
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

    # ensure the file structure is created
    file { [$flowexporter::workdir, $flowexporter::jardir, $flowexporter::gitconfdir]:
        ensure  => directory,
        owner   => 'flowexporter',
        mode    => '0750',
        require => File[$flowexporter::approot]
    }

}