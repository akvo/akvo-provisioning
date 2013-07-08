# adds the system libraries required to use mysql from python

class akvoapp::pythonsupport::mysql {
    $required_packages = ['libmysqlclient-dev']

    package { $required_packages:
        ensure => 'installed',
    }
}