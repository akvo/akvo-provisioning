
# This resource type allows you to grant a user full sudo rights

define sudo::admin_user ( $nopassword = false ) {

    if ( $nopassword ) {
        $sudocontent = template("sudo/admin_user_nopassword")
    } else {
        $sudocontent = template("sudo/admin_user")
    }

    file { "/etc/sudoers.d/${name}__admin":
        ensure  => present,
        mode    => '0440',
        owner   => 'root',
        content => $sudocontent,
    }

}