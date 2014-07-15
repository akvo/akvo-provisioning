
class watercompass::params {

    $username = 'watercompass'
    $approot = '/var/akvo/watercompass'
    $port = 8250

    $database_name = 'watercompass'
    $database_password = hiera('watercompass_database_password')

    $base_domain = hiera('base_domain')

    #    'DATABASE_URL'  => "mysql://${database_name}:${database_password}@mysql.${base_domain}/${database_name}",
    $env_vars = {
        'PYTHONPATH'    => "${approot}/code/dst:${approot}/code/dsp",
        'DATABASE_URL'  => "sqlite:///${approot}/db/watercompass.sqlite3",
        'SECRET_KEY'    => hiera('watercompass_secret_key'),
        'ALLOWED_HOSTS' => "watercompass.info,watercompass.${base_domain}",
    }

}