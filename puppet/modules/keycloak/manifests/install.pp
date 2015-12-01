# Install Keycloak and its dependencies
class keycloak::install {

  $appdir              = $keycloak::appdir
  $approot             = $keycloak::approot
  $config_dir          = $keycloak::config_dir
  $db_host             = $keycloak::db_host
  $db_name             = $keycloak::db_name
  $db_password         = $keycloak::db_password
  $db_username         = $keycloak::db_username
  $kc_release          = $keycloak::kc_release
  $port                = $keycloak::port
  $psql_driver_dir     = $keycloak::psql_driver_dir
  $psql_driver_release = $keycloak::psql_driver_release
  $psql_name           = $keycloak::psql_name

  package { 'openjdk-7-jdk':
    ensure => 'installed'
  }

  package { 'libsaxon-java':
    ensure => 'installed'
  }

  package { 'postgresql-client':
    ensure => 'installed'
  }

  user { 'keycloak':
    ensure => 'present',
    shell  => '/bin/bash',
    home   => $approot
  }

  group { 'keycloak':
    ensure => 'present',
  }

  file { "${approot}/":
    ensure  => 'directory',
    owner   => 'keycloak',
    group   => 'keycloak',
    mode    => '0700',
    require => User['keycloak']
  }

  file { "${approot}/install.sh":
    ensure  => 'present',
    owner   => 'keycloak',
    group   => 'keycloak',
    mode    => '0700',
    content => template('keycloak/install.sh.erb'),
    require => File[$approot]
  }

  exec { "${approot}/install.sh":
    user    => 'keycloak',
    cwd     => $approot,
    creates => "${approot}/.installed-${kc_release}",
    require => [File["${approot}/install.sh"],
                Package['postgresql-client']]
  }

  file { "${psql_driver_dir}/module.xml":
    ensure  => 'present',
    owner   => 'keycloak',
    group   => 'keycloak',
    mode    => '0644',
    content => template('keycloak/module.xml.erb')
  }

  file { "${approot}/configure.xsl":
    ensure  => 'present',
    owner   => 'keycloak',
    group   => 'keycloak',
    mode    => '0644',
    content => template('keycloak/configure.xsl.erb')
  }

  database::psql::db { $db_name:
    psql_name => $psql_name,
    password  => $db_password
  }

}
