
class common::collectd {

    class { '::collectd':
        purge        => true,
        recurse      => true,
        purge_config => true,
    }

    $system_plugins = prefix([
        'cpu',
        'df',
        'disk',
        'entropy',
        'load',
        'memory',
        'network',
        'uptime',
        'users'
    ], 'collectd::plugin::')

    class { $system_plugins: }

    class { 'collectd::plugin::swap':
        reportbydevice => false,
        reportbytes    => true
    }

    class { 'collectd::plugin::vmem':
        verbose => true,
    }

    class { 'collectd::plugin::write_graphite':
        graphitehost => 'graphite',
        protocol     => 'tcp',
    }

}