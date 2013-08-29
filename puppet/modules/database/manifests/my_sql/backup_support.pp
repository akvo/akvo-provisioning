
class database::my_sql::backup_support {

    $backupuser = 'backup'
    $backuppassword = hiera('mysql_backup_password')

    database_user { "${backupuser}@localhost":
        ensure        => $ensure,
        password_hash => mysql_password($backuppassword),
        provider      => 'mysql',
        require       => Class['mysql::config'],
    }

    database_grant { "${backupuser}@localhost":
        privileges => [ 'Select_priv', 'Reload_priv', 'Lock_tables_priv', 'Show_view_priv' ],
        require    => Database_user["${backupuser}@localhost"],
    }

    backups::dir { 'mysql': }

#  cron { 'mysql-backup':
#    ensure  => $ensure,
#    command => '/usr/local/sbin/mysqlbackup.sh',
#    user    => 'root',
#    hour    => 23,
#    minute  => 5,
#    require => File['mysqlbackup.sh'],
#  }

#  file { 'mysqlbackup.sh':
#    ensure  => $ensure,
#    path    => '/usr/local/sbin/mysqlbackup.sh',
#    mode    => '0700',
#    owner   => 'root',
#    group   => 'root',
#    content => template('mysql/mysqlbackup.sh.erb'),
#  }

#  file { 'mysqlbackupdir':
#    ensure => 'directory',
#    path   => $backupdir,
#    mode   => '0700',
#    owner  => 'root',
#    group  => 'root',
#  }

}