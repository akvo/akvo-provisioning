
class role::backupserver {
    notice("Including role: backup server")

    class { '::backupserver': }
}