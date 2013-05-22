# installs the system packages required to use lxml

class akvoapp::pythonsupport::lxml {

    $required_packages = ['libxslt1-dev', 'libxml2-dev']

    package { $required_packages:
        ensure => 'installed'
    }

}
