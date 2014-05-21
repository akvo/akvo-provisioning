
class memcached {
    package { 'memcached':
        ensure => installed
    }
    common::collectd_plugin { 'memcached': }
}