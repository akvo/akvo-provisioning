define supervisord::service (
   $user, $command, $directory = undef, $env_vars = undef ) {

   include supervisord::update

   file { "/etc/supervisor/conf.d/${name}.conf":
       ensure  => 'present',
       content => template("supervisord/program.conf"),
       require => Package['supervisor'],
       notify  => Class['Supervisord::Update'],
   }

}