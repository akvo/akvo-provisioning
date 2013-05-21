
class common::resolve {

    $search_domain = hiera('base_domain')
    if ($::environment == 'localdev') {
        # we hardcode this as there's not an easy way to
        # magically discover it
        $nameserver_ip = '192.168.50.101'
    }

    file { '/etc/resolv.conf':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 444,
        content => template('common/resolve.conf.erb')
    }

}