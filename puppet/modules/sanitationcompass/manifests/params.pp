
class sanitationcompass::params {

    $username = 'sanitationcompass'
    $approot = '/var/akvo/sanitationcompass'
    $port = 8200

    $database_name = 'sanitcompass'
    $database_password = hiera('sanitationcompass_database_password')

    $base_domain = hiera('base_domain')

    # mysql://${database_name}:${database_password}@mysql/${database_name}",
    $env_vars = {
        'PYTHONPATH'    => "${approot}/code/dsp",
        'DATABASE_URL'  => "sqlite:////${approot}/db/sanitationcompass.sqlite3",
        'SECRET_KEY'    => hiera('sanitationcompass_secret_key'),
        'ALLOWED_HOSTS' => "sanitationcompass.info,sanitationcompass.${base_domain}",
        'DEBUG'         => hiera('sanitationcompass_debug', 'false'),
    }

}