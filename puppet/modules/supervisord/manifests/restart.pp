# This causes a restart of a supervisor process; it is used along with
# Notify to restart a supervisor process when one of its relevant config
# files changes, without needing to trigger a refresh of the entire supervisor
# daemon

define supervisord::restart {

    exec { "supervisor_restart_$name":
        command => "/usr/bin/supervisorctl restart $name",
        user => "root",
    }

}