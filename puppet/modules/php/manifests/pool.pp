
define php::pool( $poolname, $pooluser, $poolgroup, $poolport, $poolprocs, $rootdir ) {

    file { "/etc/php5/fpm/pool.d/${poolname}.conf":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('php/pool.erb'),
        require => Package['php5-fpm']
    }

}
