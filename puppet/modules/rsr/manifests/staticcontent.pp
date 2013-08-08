define rsr::staticcontent ($approot, $media_root) {

    file { "${media_root}/${name}":
        ensure  => 'link',
        target  => "${approot}/code/akvo/mediaroot/${name}",
        require => File[$media_root],
    }
}