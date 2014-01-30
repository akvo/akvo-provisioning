
class butler::params {
    
    # some shared config
    $username = 'butler'
    $dbname = $username
    $approot = '/var/akvo/butler'
    $database_password = hiera('butler_database_password')
    $base_domain = hiera('base_domain')
    $puppetdb_server = hiera('puppetdb_server')
    $puppetdb_url = "https://${puppetdb_server}"
    $database_host = "mysql.${base_domain}"
    $database_url = "mysql://${username}:${database_password}@${database_host}/${dbname}"
    $media_root = "${approot}/mediaroot/"
    $logdir = "${approot}/logs/"
    $port = 8010
    $butler_debug = hiera('butler_debug', false)
    $butler_secret_key = hiera('butler_secret_key')
    $debug = hiera('butler_debug', false)

    $env_vars = {
        'DEBUG'                  => $debug,
        'DJANGO_SETTINGS_MODULE' => 'butler.settings',
        'SECRET_KEY'             => hiera('butler_secret_key'),
        'PUPPETDB_URL'           => $puppetdb_url,
        'DATABASE_URL'           => $butler::params::database_url,
        'BUTLER_PUPPETDB_KEY'    => "${approot}/ssl/puppetdb_key",
        'BUTLER_PUPPETDB_CERT'   => "${approot}/ssl/puppetdb_cert",
        'STATIC_ROOT'            => "${media_root}/static",
        'MEDIA_ROOT'             => "${media_root}/media",
    }

}