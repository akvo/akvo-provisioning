# This class populates the /etc/hosts file to include all necessary domain lookups
# This is a temporary hack until DNS is sorted out

class common::hosts {

    file { '/etc/hosts':
        ensure   => present,
        owner    => root,
        group    => root,
        mode     => 644,
        content  => template('common/hosts.erb')
    }

}