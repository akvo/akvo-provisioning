
class javasupport::leiningen ($user, $install_path) {

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
    } ->

    exec { "lein/run":
        command => "${bindir}/lein",
        user    => $user,
        cwd     => $install_path,
        environment => ["HOME=${install_path}"],
        creates => "${install_path}/.lein"
    }

}
