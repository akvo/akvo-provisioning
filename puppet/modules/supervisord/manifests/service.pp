define supervisord::service (
   $user, $command,
   $directory = undef,
   $stopsignal = undef,
   $env_vars = undef,
   $logdir = undef
) {

    include supervisord
    include supervisord::update

    if ($logdir == undef) {
        $stdout_logfile = 'AUTO'
        $stderr_logfile = 'AUTO'
    } else {
        $stdout_logfile = "${logdir}/${name}.stdout.log"
        $stderr_logfile = "${logdir}/${name}.stderr.log"
    }

    file { "/etc/supervisor/conf.d/${name}.conf":
        ensure  => 'present',
        content => template("supervisord/program.conf"),
        require => Package['supervisor'],
        notify  => Class['Supervisord::Update'],
    }

}