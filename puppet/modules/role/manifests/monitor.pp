class role::monitor {
    notice("Including role: monitor")

    include munin::master
    include graphite::server
    include statsd
}