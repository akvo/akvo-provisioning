
class javasupport::leiningen {

    file { '/opt/leiningen':
        ensure => directory,
        owner  => root,
        mode   => '0755'
    }

    file { '/opt/leiningen/lein':
        ensure  => file,
        owner   => root,
        mode    => '0755',
        source  => 'puppet:///modules/javasupport/lein',
        require => File['/opt/leiningen']
    }

}