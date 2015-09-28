# == Class: akvoplatform::params
#
# Used to set and validate akvoplatform parameters
#
# This is a private class, do not include directly
#
class akvoplatform::params {

    ##### DOCKER
    $docker_version = hiera('docker_version', undef)
    $docker_dns = hiera('docker_dns', '8.8.8.8')
    unless is_ip_address("${docker_dns}") { fail ("Docker DNS is not an IP address.") }


    ##### MESOS
    $mesos_version = hiera('mesos_version', undef)
    $mesos_masters = hiera_array('mesos_masters', [])
    $mesos_slaves  = hiera_array('mesos_slaves', [])
    unless is_array($mesos_masters) { fail ("Malformed 'mesos_masters' array.") }
    unless is_array($mesos_slaves)  { fail ("Malformed 'mesos_slaves' array.") }
    if empty($mesos_masters) { fail ("You need to specify at least one mesos master using hiera key 'mesos_masters'.") }
    if empty($mesos_slaves) { fail ("You need to specify at least one mesos slave using hiera key 'mesos_slaves'.") }

    $mesos_daemon_listen_address = hiera('external_ip')
    unless is_ip_address($mesos_daemon_listen_address) { fail ("Listening IP address is not a valid IP address.") }

    $role = hiera('akvoplatform_role')
    validate_string($role)
    case $role {
        'master': {
            unless member($mesos_masters, $mesos_daemon_listen_address) { fail ("Listening IP address is not an expected mesos master.") }
        }
        'slave': {
            unless member($mesos_slaves, $mesos_daemon_listen_address) { fail ("Listening IP address is not an expected mesos slave.") }
        }
        default: { fail ("Akvo platform node role must be either 'master' or 'slave'.") }
    }
    notice ("*** This is a '${role}' node.")

    if $role == 'slave' {
        validate_string($::environment)
        notice ("*** Node configured as a member of the '${::environment}' environment.")
    }

    $mesos_masters_print = join($mesos_masters, ',')
    $mesos_slaves_print = join($mesos_slaves, ',')
    notice ("*** Mesos masters: '${mesos_masters_print}'")
    notice ("*** Mesos slaves: '${mesos_slaves_print}'")


    ##### ZOOKEEPER
    $zk_mesos_url    = join([ "zk://", join($mesos_masters, ':2181,'), ":2181/mesos" ], '')
    notice ("*** Zookeeper mesos URL: '${zk_mesos_url}'.")

    # dynamically configure zookeeper 'myid' based on mesos_masters index
    # class defined to allow setting this value within the lambda code below
    class zk_config ( $myid = undef ) {}

    if $role == 'master' {
        $zk_marathon_url = join([ "zk://", join($mesos_masters, ':2181,'), ":2181/marathon" ], '')
        notice ("*** Zookeeper marathon URL: '${zk_marathon_url}'.")

        $zk_quorum = size($mesos_masters) / 2 + 1
        validate_integer($zk_quorum, undef, 1)
        notice ("*** Zookeeper QUORUM set to '${zk_quorum}'.")

        $mesos_masters.each |$index, $master| {
            if $master == hiera('internal_ip') {
                class { 'zk_config': myid => $index + 1 }
            }
        }
        # zk myid should be a value between 1 and 255
        validate_integer($zk_config::myid, 255, 1)
        notice (" *** Zookeeper ID = '${zk_config::myid}'.")
    }


    ##### CONSUL
    $consul_version = hiera('consul_version', '0.5.2')
    # using 'internal_ip' as nginx proxies requests to consul listening on 127.0.0.1:8500
    $consul_backend = hiera('internal_ip')


    ##### INTERNAL SERVICES PORTS
    $mesos_master_port = hiera('mesos_master_port', 5050)
    $mesos_slave_port = hiera('mesos_slave_port', 5051)
    $mesos_slave_docker_ports = hiera('mesos_slave_docker_ports', '31000-32000')
    $marathon_port = hiera('mesos_marathon_port', 8080)
    $zookeeper_client_port = hiera('mesos_zookeeper_client_port', 2181)
    $zookeeper_server_ports = hiera('mesos_zookeeper_server_ports', [2888, 3888]) # election and leader port respectively
    $lb_proxy_port = hiera('mesos_lb_proxy_port', 80)


    ##### DOMAINS
    $base_domain   = hiera('base_domain', '')
    $public_domain = hiera('public_domain', '')

}
