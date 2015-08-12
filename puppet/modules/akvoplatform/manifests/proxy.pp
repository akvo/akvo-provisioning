# == Class: akvoplatform::proxy
#
# This class configures a proxy to services running on a given Akvo platform.
#
class akvoplatform::proxy inherits akvoplatform::params {

    # basic nginx installation
    include nginx

    # install and configure consul-template
    class { '::consul_template':
        purge_config_dir => true,
        init_style       => 'upstart'
    }

    # add watcher to dynamically adapt nginx configuration.
    # appending "|| true" to command to let consul template continue 
    # watching for changes, even if the optional command argument fails
    # TODO add SSL config
    consul_template::watch { 'nginx':
        template    => 'akvoplatform/proxy.conf.ctmpl.erb',
        destination => '/etc/nginx/sites-enabled/proxy.conf',
        command     => 'service nginx reload || true',
        notify      => Service["consul-template"]               #TODO to be removed when using v0.2.0 of 'gdhbashton/puppet-consul_template'
    }

}
