
class flowexporter::params {

    # some shared config
    $username = 'flowexporter'
    $approot = '/var/akvo/flowexporter'

    $workdir = "${approot}/work"
    $jardir = "${approot}/jars"
    $logdir = "${approot}/logs"
    $gitconfdir = "${approot}/akvo-flow-services-config"

    $google_password = hiera('flowexporter_google_password')

    $port = 8020

}