# a leech is a machine which wants to copy data from a data source - typically,
# this is to get live data onto test environments

class homepage::leech inherits homepage::params  {
    $data_source_host = hiera('homepage_data_source_host')

    # if we are not a source, then we are a leech, and so we need the private
    # key in order to log in to the source machine(s) to fetch media
    file { "${appdir}/.ssh/homepageleech":
        ensure  => present,
        owner   => 'homepage',
        group   => 'homepage',
        mode    => '0600',
        content => hiera('homepage_leech_private_key'),
        require => File["${appdir}/.ssh"]
    }

    # and some helper scripts to enable developers and CI to run the
    # copying and import process easily
    file { "${appdir}/leech_media.sh":
        ensure  => present,
        owner   => 'homepage',
        group   => 'homepage',
        mode    => '0744',
        content => template('homepage/leech_media.sh.erb'),
        require => File[$appdir]
    }

    file { "${appdir}/leech_db.sh":
        ensure  => present,
        owner   => 'homepage',
        group   => 'homepage',
        mode    => '0744',
        content => template('homepage/leech_db.sh.erb'),
        require => File[$appdir]
    }

}