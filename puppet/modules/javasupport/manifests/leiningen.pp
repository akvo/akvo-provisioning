
class javasupport::leiningen {

    $bindir = '/opt/leiningen'

    file { $bindir:
        ensure => directory,
        owner  => root,
        mode   => '0755'
    }

    file { "${bindir}/lein":
        ensure  => file,
        owner   => root,
        mode    => '0755',
        source  => 'puppet:///modules/javasupport/lein',
        require => File['/opt/leiningen']
    }

}
