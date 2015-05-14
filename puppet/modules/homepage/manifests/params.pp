
class homepage::params {

    $username = 'homepage'
    $appdir = '/var/akvo/homepage'

    $mysql_name = hiera('homepage_wordpress_database_mysql_name', 'mysql')
    $db_password = hiera('homepage_wordpress_database_password')

    $specified_hostnames = hiera('homepage_hostnames')
    $base_domain = hiera('base_domain')
    $default_hostname = ["homepage.${base_domain}"]
    $homepage_hostnames = concat($default_hostname, $specified_hostnames)
    $homepage_url = hiera('homepage_url')
    $rsr_domain = hiera('rsr_main_domain') # for legacy redirects
    $pool_port = 9010
    $piwik_id = hiera('homepage_piwik_id')
    $piwik_domain = hiera('homepage_piwik_domain')

    $db_host = "${mysql_name}.${base_domain}"

}
