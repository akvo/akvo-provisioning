
class fw::pre {
    Firewall {
        require => undef,
    }

    # Default firewall rules
    firewall { '000 accept all icmp':
        proto   => 'icmp',
        action  => 'accept',
    }->
    firewall { '001 accept all to lo interface':
        proto   => 'all',
        iniface => 'lo',
        action  => 'accept',
    }->
    firewall { '002 accept related established rules':
        proto   => 'all',
        ctstate => ['RELATED', 'ESTABLISHED'],
        action  => 'accept',
    }
}