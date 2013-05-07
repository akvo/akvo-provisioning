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

    file { "/puppet/bin/apply.sh":
        ensure  => "present",
        owner   => "puppet",
        group   => "puppet",
        mode    => 700,
        source  => 'puppet:///modules/puppetcontrol/apply.sh',
    }

    sudo::allow_command { "puppet_apply":
        user    => "puppet",
        command => "/puppet/bin/apply",
        require => File["/puppet/bin/apply.sh"],
    }
}
