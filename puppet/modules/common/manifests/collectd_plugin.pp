
define common::collectd_plugin ($args = nil) {

    if ( !hiera('lite', false) ) {
        if ($args == nil) {
            $args_val = { "collectd::plugin::${name}" => {} }
        } else {
            $args_val = { "collectd::plugin::${name}" => $args }
        }

        create_resources('class', $args_val)
    }

}