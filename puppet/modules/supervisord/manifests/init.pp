class supervisord {

    package { 'supervisor':
        ensure => 'present',
    }

}