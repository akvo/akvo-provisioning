
class homepage::install inherits homepage::params {

    php::app { 'homepage':
        app_hostnames        => $homepage_hostnames,
        group                => 'www-edit',
        pool_port            => $pool_port,
        config_file_contents => template('homepage/homepage-nginx.conf.erb')
    }

    file { ["${appdir}/versions", "${appdir}/conf", "${appdir}/uploads"]:
        ensure  => directory,
        owner   => 'homepage',
        group   => 'homepage',
        mode    => '0775',
        require => File[$appdir]
    }

    file { "${appdir}/make_version.sh":
        ensure  => present,
        owner   => 'homepage',
        group   => 'homepage',
        mode    => '0544',
        content => template('homepage/make_version.sh.erb'),
        require => File[$appdir]
    }

    if (!$plugins_from_repo) {
        file { "${appdir}/plugins":
            ensure  => directory,
            owner   => 'homepage',
            group   => 'homepage',
            mode    => '0775',
            require => File[$appdir]
        }
    }

}