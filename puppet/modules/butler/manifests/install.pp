
class butler::install {

    # we need the config
    include butler::params

    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    akvoapp { $butler::params::username:
        deploy_key => hiera('butler-deploy_public_key')
    }

    
    # install all of the support packages
    include pythonsupport::mysql
    include pythonsupport::standard

    
    # create all of the directories
    $approot = $butler::params::approot
    $username = $butler::params::username
    $env_vars = $butler::params::env_vars
    $media_root = $butler::params::media_root


    # make sure the mediaroot exists
    file { $media_root:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => Akvoapp['butler']
    }
    
    
    # include the script for updating
    file { "${approot}/update.sh":
        ensure  => present,
        content => template('butler/update.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    # include the script for managing the django application
    file { "${approot}/manage.sh":
        ensure  => present,
        content => template('butler/manage.sh.erb'),
        owner   => $username,
        group   => $username,
        mode    => '0744',
        require => File[$approot]
    }

    file { "${approot}/ssl":
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0500',
        require => File[$approot]
    }

    file { "${approot}/ssl/puppetdb_key":
        ensure  => present,
        content => hiera('butler_puppetdb_key'),
        owner   => $username,
        group   => $username,
        mode    => '0500',
        require => File[$approot]
    }

    file { "${approot}/ssl/puppetdb_cert":
        ensure  => present,
        content => hiera('butler_puppetdb_cert'),
        owner   => $username,
        group   => $username,
        mode    => '0500',
        require => File[$approot]
    }

}