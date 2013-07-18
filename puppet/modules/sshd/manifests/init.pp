class sshd {

    package { 'openssh-server':
        ensure => present,
    }
  
    file { '/etc/ssh/sshd_config':
        ensure  => file,
        mode    => 600,
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/sshd/sshd_config',
        require => Package['openssh-server']
    }
  
    service { 'ssh':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        subscribe => File['/etc/ssh/sshd_config'],
    }

    # Export ssh key for the hostnames
    $host_aliases = [ hiera('internal_ip'), hiera('external_ip') ]
    @@sshkey { $::fqdn:
        ensure       => present,
        host_aliases => $host_aliases,
        type         => 'rsa',
        key          => $::sshrsakey,
    }

    # Import hostkeys to all hosts.
    Sshkey <<| |>>

}
