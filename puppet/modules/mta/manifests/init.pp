
class mta {

    package { ['postfix', 'mailutils']:
        ensure => installed,
    }

    package { 'sendmail':
        ensure => absent
    }

    $mail_relay = hiera('mail_relay')
    $mail_user = hiera('mail_relay_user')
    $mail_password = hiera('mail_relay_password')
    $base_domain = hiera('base_domain')

    file { '/etc/postfix/main.cf':
        ensure  => present,
        mode    => '0444',
        owner   => 'root',
        content => template('mta/main.cf.erb'),
        require => Package['postfix']
    }

    file { '/etc/postfix/sasl_passwd':
        ensure  => present,
        mode    => '0600',
        owner   => 'root',
        content => template('mta/sasl_passwd.erb'),
        require => Package['postfix']
    } ~>

    exec { '/usr/sbin/postmap /etc/postfix/sasl_password':
        user => 'root'
    } ~>

    service { 'postfix':
        ensure => running
    }

}
