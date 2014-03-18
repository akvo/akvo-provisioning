
define systemstats::stat ( $user = 'stats' ) {

    file { "/var/stats/bin/${name}.sh":
        ensure  => present,
        owner   => $user,
        mode    => '0744',
        require => File['/var/stats/bin'],
        content => template("systemstats/${name}.sh.erb")
    }

    cron { "stats_sender_${name}":
        command => "bash -c /var/stats/bin/${name}.sh",
        user    => $user,
        hour    => '*',
        minute  => '*/2'
    }

}