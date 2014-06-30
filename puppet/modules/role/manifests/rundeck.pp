
class role::rundeck {
    notice("Including role: Rundeck")
    class { '::rundeck': }
}