
class homepage::params {

    $appdir = '/var/akvo/homepage'

    $mysql_name = hiera('homepage_wordpress_database_mysql_name', 'mysql')
    $db_password = hiera('homepage_wordpress_database_password')

    $specified_hostnames = hiera('homepage_hostnames')
    $base_domain = hiera('base_domain')
    $default_hostname = ["homepage.${base_domain}"]
    $homepage_hostnames = concat($default_hostname, $specified_hostnames)
    $rsr_domain = hiera('rsr_main_domain') # for legacy redirects

    $plugins_from_repo = hiera('homepage_plugins_from_repository', true)
    if ($plugins_from_repo) {
        $plugin_dir = "${appdir}/code/wp-content/plugins"
    } else {
        $plugin_dir = "${appdir}/plugins"
    }

    $db_host = "${mysql_name}.${base_domain}"

}