
class watercompass::params {

    $username = 'watercompass'
    $approot = '/var/akvo/watercompass'
    $port = 8100

    $database_name = 'sanitcompass'
    $database_password = hiera('watercompass_database_password')

    $base_domain = hiera('base_domain')

    $env_vars = {
        'PYTHONPATH'    => "${approot}/code/dsp",
        'DATABASE_URL'  => "mysql://${database_name}:${database_password}@mysql/${database_name}",
        'SECRET_KEY'    => hiera('watercompass_secret_key'),
        'ALLOWED_HOSTS' => "watercompass.info,watercompass.${base_domain}",
    }

}