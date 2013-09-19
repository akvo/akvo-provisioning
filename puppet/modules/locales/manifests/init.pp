class locales {
    package { "locales":
        ensure => latest,
    }

    file { "/etc/locale.gen":
        source => "puppet:///modules/locales/locale.gen",
        owner => "root",
        group => "root",
        mode => '0644',
        require => Package['locales'],
    }

    exec { "/usr/sbin/locale-gen":
        subscribe => File["/etc/locale.gen"],
        refreshonly => true,
        require => [ Package['locales'], File["/etc/locale.gen"] ],
    }

    file { "/etc/default/locale":
        owner => "root",
        group => "root",
        mode  => '0644',
        require => Package['locales'],
        content => "LC_ALL=en_US.UTF-8",
    }
}