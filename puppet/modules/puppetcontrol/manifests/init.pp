class puppetcontrol {

    # This class installs and configures everything necessary for this node to function
    # autonomously as a puppet agent. Note that this does not bootstrap the node - a
    # separate script is required to do that. This fills in the missing details once that
    # bootstrap script has been run - see 'bootstrap.sh'

    file { "/puppet/bin/":
        ensure  => "directory",
        owner   => "puppet",
        group   => "puppet",
        mode    => "700",
    }


    # copy the helper script in
    file { "/puppet/bin/apply.sh":
        ensure  => "present",
        owner   => "puppet",
        group   => "puppet",
        mode    => 700,
        source  => 'puppet:///modules/puppetcontrol/apply.sh',
    }


    # link the helper script so it's on the path
    file { "/usr/bin/update_system_config":
        owner   => root,
        group   => root,
        mode    => 555,
        source  => 'puppet:///modules/puppetcontrol/update_system_config',
        require => File["/puppet/bin/apply.sh"],
    }


    # let the puppet user apply the puppet config
    sudo::allow_command { "update_system_config":
        user    => "puppet",
        command => "/puppet/bin/apply.sh",
        require => File["/puppet/bin/apply.sh"],
    }


    # configure puppet
    file { '/etc/puppet/puppet.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '444',
        source  => 'puppet:///modules/puppetcontrol/puppet.conf',
    }


    # connect it to the puppetdb server
    # note it is imperative that the puppetdb server is already configured and running!
    $base_domain = hiera('base_domain')
    $puppetdb_server = "puppetdb.${base_domain}"
    file { '/etc/puppet/puppetdb.conf':
        ensure  => present,
        owner   => 'root',
        mode    => '444',
        content => template('puppetcontrol/puppetdb.conf.erb'),
    }

    file { '/etc/puppet/routes.yaml':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '444',
        source  => 'puppet:///modules/puppetcontrol/routes.yaml',
    }


    # configure hiera
    file { '/etc/puppet/hiera.yaml':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '444',
        source => 'puppet:///modules/puppetcontrol/hiera.yaml',
    }
}
