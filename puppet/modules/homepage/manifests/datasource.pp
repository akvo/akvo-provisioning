
# if a machine is a data source (ie, we are the place where media gets created, which
# basically means the live site) then we have an 'homepageleech' user which
# will allow *read-only* access to our media store and db from other machines

class homepage::datasource inherits homepage::params {

    # various fs structure required for a remote leech to log in
    user { 'homepageleech':
        ensure => present,
        home   => "${appdir}/leech"
    }

    file { ["${appdir}/leech", "${appdir}/leech/.ssh"]:
        ensure  => directory,
        owner   => 'homepageleech',
        group   => 'homepageleech',
        mode    => '0700',
        require => User['homepageleech']
    }

    file { "${appdir}/leech/.ssh/authorized_keys":
        ensure  => present,
        owner   => 'homepageleech',
        group   => 'homepageleech',
        mode    => '0600',
        require => File["${appdir}/leech/.ssh"]
    }

    ssh_authorized_key { 'leech-authorized-key':
        ensure  => present,
        key     => hiera('homepage_leech_public_key'),
        type    => 'ssh-rsa',
        user    => 'homepageleech',
        require => File["${appdir}/leech/.ssh/authorized_keys"]
    }

    # helpers to run the export tools
    file { "${appdir}/leech/dumpdb.sh":
        ensure  => present,
        owner   => 'homepageleech',
        group   => 'homepageleech',
        mode    => '0700',
        content => template('homepage/leech_dump_db.sh.erb'),
        require => File["${appdir}/leech"]
    }
}