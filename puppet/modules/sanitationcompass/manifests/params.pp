
class sanitationcompass::params {

    $username = 'sanitationcompass'
    $approot = '/var/akvo/sanitationcompass'
    $port = 8100

    $database_password = hiera('sanitationcompass_database_password')

}