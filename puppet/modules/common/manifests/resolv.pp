
class common::resolv {

    $domain = hiera('base_domain')

    file_line { 'add_search_domain':
        ensure => present,
        path   => '/etc/resolv.conf',
        match  => '^search.*$',
        line   => "search ${domain}",
    }

}