
class mta {

    package { 'postfix', 'mailutils':
        ensure => installed,
    }

    $base_domain = hiera('base_domain')
    file { '/etc/postfix/main.cf':
        ensure  => present,
        mode    => '0440',
        owner   => 'root',
        content => template('mta/main.cf.erb'),
        require => Package['postfix']
    }

}