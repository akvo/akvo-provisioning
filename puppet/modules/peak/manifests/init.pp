class peak {

    sudo::admin_user { 'lynn': }

    backups::dir { "wordpress_data":
        path => "/var/akvo/peak"
    }

    firewall { '200 allow httpd access':
        port   => [80, 443],
        proto  => tcp,
        action => accept,
    }

}
