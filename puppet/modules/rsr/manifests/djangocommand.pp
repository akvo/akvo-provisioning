define rsr::djangocommand( $command = undef ) {

    $manage = '/apps/rsr/venv/bin/python /apps/rsr/checkout/akvo/manage.py'
    $torun = pick($command, $name)

    exec { "rsr_command_${torun}":
        command   => "${manage} ${torun}",
        cwd       => '/apps/rsr/',
        user      => 'rsr',
        logoutput => 'true',
    }

}