# == Class: ecs::params
#
# Used to set and validate ecs parameters
# This is a private class, do not include directly
#
class ecs::params {

    ##### DOCKER
    $docker_version = hiera('docker_version', undef)
    $docker_dns = hiera('docker_dns', '8.8.8.8')
    unless is_ip_address("${docker_dns}") { fail ("DNS provided is not a valid IP address.") }

    ##### AWS
    $aws_region = hiera('aws_region', 'eu-west-1')
    $aws_access_key = hiera('aws_access_key')
    $aws_secret_access = hiera('aws_secret_access')

}
