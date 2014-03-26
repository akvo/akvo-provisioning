
class memcached {
    package { 'memcached':
        ensure => installed
    }
    class { 'collectd::plugin::memcached': }
}