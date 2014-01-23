
class butler::params {
    
    # some shared config
    $username = 'butler'
    $approot = '/var/akvo/butler'
    $database_password = hiera('butler_database_password')
    $base_domain = hiera('base_domain')
    $database_host = "mysql.${base_domain}"
    $media_root = "${approot}/mediaroot/"
    $logdir = "${approot}/logs/"
    $port = 8010
    $butler_debug = hiera('butler_debug', false)
    $butler_secret_key = hiera('butler_secret_key')

}