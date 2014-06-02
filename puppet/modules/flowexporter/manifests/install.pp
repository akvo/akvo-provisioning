
class flowexporter::install {

    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    akvoapp { 'flowexporter':
        deploy_key => hiera('flowexporter-deploy_public_key')
    }

    # we need the config
    include flowexporter::params

    # and some supporting packages
    package { 'openjdk-7-jre':
        ensure => 'installed'
    }

}