
class rsr::params {

    # some shared config
    $username = 'rsr'
    $approot = '/var/akvo/rsr'
    $database_password = hiera('rsr_database_password')
    $base_domain = hiera('base_domain')
    $mysql_name = hiera('rsr_mysql_name', 'mysql')
    $database_host = "${mysql_name}.${base_domain}"
    $media_root = "${approot}/mediaroot/"
    $static_root = "${approot}/staticroot/"
    $logdir = "${approot}/logs/"
    $port = 8000
    $site_id = hiera('rsr_site_id')
    $rsr_debug = hiera('rsr_debug', false)
    $main_domain = hiera('rsr_main_domain', "rsr.${base_domain}")
    $smtp_user = hiera('rsr_smtp_user')
    $smtp_password = hiera('rsr_smtp_password')

    $rsr_secret_key = hiera('rsr_secret_key')
    $additional_rsr_domains = hiera_array('rsr_additional_rsr_domains', [])
    $partner_site_domain = hiera('rsr_partner_site_domain')

    $rsr_hostnames = concat($additional_rsr_domains, ["rsr.${base_domain}"])

    $postgres_name = hiera('rsr_psql_name', 'psql')
    $postgres_database_host = "${postgres_name}.${base_domain}"

}