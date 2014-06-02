
class flowexporter::params {

    # some shared config
    $username = 'flowexporter'
    $approot = '/var/akvo/flowexporter'

    $workdir = "${approot}/work"
    $jardir = "${approot}/jars"
    $logdir = "${approot}/logs"
    $gitconfdir = "${approot}/akvo-flow-services-config"

    $port = 8020

}