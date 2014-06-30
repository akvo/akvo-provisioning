
class rundeck::config {

    $base_domain = hiera('base_domain')
    $server_name = "rundeck.${base_domain}"
    $server_url = "http://${server_name}"

    file { '/etc/rundeck/rundeck-config.properties':
        ensure   => present,
        owner    => 'rundeck',
        group    => 'rundeck',
        content  => template('rundeck/rundeck-config.properties.erb')
    }

    nginx::proxy { $server_name:
        proxy_url          => "http://localhost:4440",
    }

}