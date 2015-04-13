class unilog::install {

    # installs OpenJDK Java runtime
    include javasupport

    # lein installed at /opt/leiningen - binary file static to v2.5.1
    include javasupport::leiningen

    #    $user        = 'vagrant'
    #    $bindir      = "/usr/local/bin"
    #    $package_uri = 'https://raw.github.com/technomancy/leiningen/stable/bin/lein'
    #    $binary_name = 'lein'
    #
    #    exec { 'leiningen/install':
    #        #user    => $user,
    #        #group   => $user,
    #        path    => ["/bin", "/usr/bin", "/usr/local/bin"],
    #        cwd     => $bindir,
    #        command => "wget ${package_uri} && chmod 755 ${binary_name}",
    #        creates => "${bindir}/${binary_name}"
    #    }

}
