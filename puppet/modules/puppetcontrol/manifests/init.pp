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


    # let the puppet user apply the puppet config
    sudo::allow_command { "puppet_apply":
        user    => "puppet",
        command => "/puppet/bin/apply",
        require => File["/puppet/bin/apply.sh"],
    }


    # configure puppet
    file { '/etc/puppet/puppet.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        source  => 'puppet:///modules/puppetcontrol/puppet.conf',
    }


    # connect it to the puppetdb server
    # note it is imperative that the puppetdb server is already configured and running!
    $puppetdb_server = "puppetdb.${::base_domain}"
    file { '/etc/puppet/puppetdb.conf':
        ensure  => present,
        owner   => 'root',
        mode    => '644',
        content => template('puppetcontrol/puppetdb.conf.erb'),
    }

    file { '/etc/puppet/routes.yaml':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        source  => 'puppet:///modules/puppetcontrol/routes.yaml',
    }
}
