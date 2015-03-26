class peak {

    sudo::admin_user { 'lynn': }

    backups::dir { "wordpress_data":
        path => "/var/akvo/peak"
    }

}
