
class butler::install {

    # we need the config
    include butler::params

    # make sure we also include the Akvoapp stuff, and that it is loaded
    # before this module
    akvoapp { $butler::params::username:
        deploy_key => hiera('butler-deploy_private_key')
    }

    
    # install all of the support packages
    include pythonsupport::mysql
    include pythonsupport::standard

    
    # create all of the directories
    $approot = $butler::params::approot
    $username = $butler::params::username
    $media_root = $butler::params::media_root


    # make sure the mediaroot exists
    file { $media_root:
        ensure  => directory,
        owner   => $username,
        group   => $username,
        mode    => '0755',
        require => Class['Akvoapp']
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
    
}