
class flowreportshim::install {

    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    akvoapp { 'flowreportshim':
        deploy_key => hiera('flowreportshim-deploy_public_key')
    }

    # we need the config
    include flowreportshim::params

    # and some supporting packages
    package { 'openjdk-7-jre':
        ensure => 'installed'
    }

}