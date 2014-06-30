
class rundeck::install {

    apt::source { 'bintray-rundeck':
        location => 'http://dl.bintray.com/rundeck/rundeck-deb',
        release  => '',
        repos    => '/',
        include_src => false,
    }

    package { 'rundeck':
        ensure => '2.1.2'
    }

}