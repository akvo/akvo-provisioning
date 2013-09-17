class puppetcontrol {

    # This class installs and configures everything necessary for this node to function
    # autonomously as a puppet agent. Note that this does not bootstrap the node - a
    # separate script is required to do that. This fills in the missing details once that
    # bootstrap script has been run - see 'fabfile.py#bootstrap()'

    # although there is already a puppet user due to the bootstrap step, we still define
    # it here just to make sure
    user { 'puppet':
        ensure => 'present',
        home => '/puppet',
        shell => '/bin/bash',
    }

    group { 'puppet':
        require => User['puppet']
    }

    file { '/puppet/':
       ensure => directory,
       owner => 'puppet',
       group => 'puppet',
       mode => 750,
       require => [ User['puppet'], Group['puppet'] ]
    }


    # insert the ssh info
    file { '/puppet/.ssh':
        ensure => directory,
        owner => 'puppet',
        group => 'puppet',
        mode => 700,
    }

    file { '/puppet/.ssh/authorized_keys':
        ensure => present,
        owner => 'puppet',
        group => 'puppet',
        mode => 600,
        require => File['/puppet/.ssh']
    }

    ssh_authorized_key { "puppet_key":
        ensure  => present,
        key     => hiera('puppet_public_key'),
        type    => 'ssh-rsa',
        user    => 'puppet',
        require => File['/puppet/.ssh/authorized_keys']
    }


    # add some additional helper scripts
    file { "/puppet/bin/":
        ensure  => "directory",
        owner   => "puppet",
        group   => "puppet",
        mode    => "700",
        require => File['/puppet/'],
    }

    file { "/puppet/bin/apply.sh":
        ensure  => "present",
        owner   => "puppet",
        group   => "puppet",
        mode    => 700,
        source  => 'puppet:///modules/puppetcontrol/apply.sh',
        require => File['/puppet/bin/']
    }


    # let the puppet user apply the puppet config
    sudo::allow_command { "update_system_config":
        user    => "puppet",
        command => "/puppet/bin/apply.sh",
        require => [User['puppet'], File["/puppet/bin/apply.sh"]],
    }

    # let the puppet user do package upgrades
    sudo::allow_command { "puppet_apt_update":
        user    => "puppet",
        command => "apt-get update",
        require => User['puppet'],
    }
    sudo::allow_command { "puppet_apt_upgrade":
        user    => "puppet",
        command => "apt-get upgrade",
        require => User['puppet'],
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
    $puppetdb_server = hiera('puppetdb_server')
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

    # HACKY MCTASTIC:
    # See issue #3 - https://github.com/akvo/akvo-provisioning/issues/3
    # Basically we need to add a custom fact handler due to bugs in the way
    # puppet delegates fact checking.
    file { '/usr/lib/ruby/vendor_ruby/puppet/indirector/facts/puppetdb_apply.rb':
        ensure  => present,
        source  => 'puppet:///modules/puppetcontrol/puppetdb_apply.rb'
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
