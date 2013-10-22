
class database::my_sql::reportable($dbname) {

    $reports_password = hiera('mysql_reports_password')

    mysql_user { 'reports@localhost':
        ensure        => present,
        password_hash => mysql_password($mysql_reports_password),
        provider      => 'mysql',
        require       => Class['mysql::server'],
    }

}