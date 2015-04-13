class opendata::params {

    $hostnames      = hiera_array('opendata_hostnames')

    $ckan_version   = '2.3'
    $wsgi_host      = '127.0.0.1'
    $wsgi_port      = '8080'

    $setup_postgres = false
    $storage_path   = '/var/lib/ckan'
    $backup_dir     = '/backups/data/psql/ckan'

}
