
define common::stats_sender {

    $statsd_host = hiera('statsd_host')

    file { "/var/stats/bin/${name}.sh":
        ensure  => present,
        owner   => 'stats',
        mode    => 744,
        require => File['/var/stats/bin'],
        content => template("common/stats/${name}.sh.erb")
    }

    cron { "stats_sender_${name}":
        command => "/var/stats/bin/${name}.sh",
        user    => 'stats',
        hour    => '*',
        minute  => '*/15'
    }

}