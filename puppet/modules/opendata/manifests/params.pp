class opendata::params {

    $hostname       = hiera('opendata_hostname')
    $username       = 'opendata'
    $themedir       = '/usr/lib/ckan/default/src/akvo-opendata'

    $ckan_version   = '2.3'
    $wsgi_host      = '127.0.0.1'
    $wsgi_port      = '8080'

    $setup_postgres = false
    $storage_path   = '/var/lib/ckan/default'
    $backup_dir     = '/backups/data/psql/ckan'

}
