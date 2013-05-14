class role::everything {
    notice("Including role: everything")

    include role::basic
    include role::management
    include role::monitor
}