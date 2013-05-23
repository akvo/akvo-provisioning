# This causes an update of a supervisor process; it is used along with
# Notify to update a supervisor process' config when one of its relevant config
# files changes, without needing to trigger a refresh of the entire supervisor
# daemon

class supervisord::update {
    exec { "supervisor::update":
        command => "/usr/bin/supervisorctl update",
        user => 'root',
    }
}