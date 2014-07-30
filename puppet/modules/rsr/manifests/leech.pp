# a leech is a machine which wants to copy data from a data source - typically,
# this is to get live data onto test environments

class rsr::leech {
    $approot = $rsr::params::approot

    # if we are not a source, then we are a leech, and so we need the private
    # key in order to log in to the source machine(s) to fetch media
    file { "${approot}/.ssh/rsrleech":
        ensure  => present,
        owner   => $username,
        group   => $username,
        mode    => '0600',
        content => hiera('rsr_leech_private_key'),
        require => File["${approot}/.ssh"]
    }

    # and some helper scripts to enable developers and CI to run the
    # copying and import process easily

}