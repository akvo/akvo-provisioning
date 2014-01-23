
class butler::params {
    
    # some shared config
    $username = 'butler'
    $dbname = $username
    $approot = '/var/akvo/butler'
    $database_password = hiera('butler_database_password')
    $base_domain = hiera('base_domain')
    $database_host = "mysql.${base_domain}"
    $database_url = "mysql://${username}:${database_password}@${database_host}/${dbname}"
    $media_root = "${approot}/mediaroot/"
    $logdir = "${approot}/logs/"
    $port = 8010
    $butler_debug = hiera('butler_debug', false)
    $butler_secret_key = hiera('butler_secret_key')

    $env_vars = {
        'SECRET_KEY' => hiera('butler_secret_key'),
        'PUPPETDB_URL' => hiera('puppetdb_server'),
        'DATABASE_URL' => $butler::params::database_url
    }

}