
# if a machine is a data source (ie, we are the place where media gets created, which
# basically means the live site) then we have an 'rsrleech' user which
# will allow *read-only* access to our media store and db from other machines

class rsr::datasource {

    # various fs structure required for a remote leech to log in
    user { 'rsrleech':
        ensure => present,
        home   => "${approot}/leech"
    }

    file { ["${approot}/leech", "${approot}/leech/.ssh"]:
        ensure  => directory,
        owner   => 'rsrleech',
        group   => 'rsrleech',
        mode    => '0700',
        require => User['rsrleech']
    }

    file { "${approot}/leech/.ssh/authorized_keys":
        ensure  => present,
        owner   => 'rsrleech',
        group   => 'rsrleech',
        mode    => '0600',
        require => File["${approot}/leech/.ssh"]
    }

    ssh_authorized_key { 'medialeech-authorized-key':
        ensure  => present,
        key     => hiera('rsr_media_leech_public_key'),
        type    => 'ssh-rsa',
        user    => 'rsrleech',
        require => File["${approot}/leech/.ssh"]
    }

    # helpers to run the export tools
}