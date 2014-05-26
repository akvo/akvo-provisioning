class javasupport::gae {

    $gae_version = 'appengine-java-sdk-1.8.9.zip'
    $gae_sdk = "https://storage.googleapis.com/appengine-sdks/featured/${gae_version}"

    file { '/opt/gae':
        ensure => directory,
        owner => root,
        mode => '0755'
    }

    exec { 'install_gae_sdk':
        command => "/usr/bin/wget ${gae_sdk} && /usr/bin/unzip ${gae_version}",
        cwd     => '/opt/gae',
        creates => "/opt/gae/${gae_version}",
        require => File['/opt/gae']
    }

}