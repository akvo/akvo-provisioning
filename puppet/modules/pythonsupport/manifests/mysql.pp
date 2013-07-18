# adds the system libraries required to use mysql from python

class pythonsupport::mysql {
    $required_packages = ['libmysqlclient-dev']

    package { $required_packages:
        ensure => 'installed',
    }
}