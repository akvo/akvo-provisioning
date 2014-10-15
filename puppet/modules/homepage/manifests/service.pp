
class homepage::service {

    # we want the homepage user to be able to restart the process
    sudo::allow_command { "homepage-stop-service":
        user    => 'homepage',
        command => '/etc/init.d/php5-fpm stop'
    }

    sudo::allow_command { "homepage-start-service":
        user    => 'homepage',
        command => '/etc/init.d/php5-fpm start'
    }

}