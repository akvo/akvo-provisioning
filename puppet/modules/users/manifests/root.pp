class users::root {

  file { '/root/.screenrc':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/users/screenrc',
  }

}
