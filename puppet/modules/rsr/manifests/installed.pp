# this class represents a copy of RSR which is fixed and installed,
# and which is updated by an automatic deployment process.

class rsr::installed {
    include rsr::common

    $approot = $rsr::common::approot

    # create the two 'sides'
    file { [ "${approot}/git/side_a", "${approot}/git/side_b" ]:
        ensure  => directory,
        owner   => 'rsr',
        group   => 'rsr',
        mode    => 755,
        require => File[$approot]
    }

    # include the script for switching sides
    file { "${approot}/switch_sides.sh":
        ensure  => present,
        content => template('rsr/switch_sides.sh.erb'),
        owner   => 'rsr',
        group   => 'rsr',
        mode    => 744,
        require => File[$approot]
    }
}