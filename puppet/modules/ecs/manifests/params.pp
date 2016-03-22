# == Class: ecs::params
#
# Used to set and validate ecs parameters
# This is a private class, do not include directly
#
class ecs::params {

    ##### Docker
    $docker_version = hiera('docker_version', undef)

    ##### AWS
    $aws_region = hiera('aws_region', 'eu-west-1')
    $aws_access_key = hiera('aws_access_key')
    $aws_secret_access = hiera('aws_secret_access')

    #### SSL Certificates
    $path = hiera('cert_keys_path', '/etc/nginx/certs/')
    $hostnames = hiera_array('cartodb_hostnames')

}
