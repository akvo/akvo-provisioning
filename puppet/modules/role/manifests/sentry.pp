
class role::sentry {
    notice('Including role: Sentry')
    class { '::sentry': }
}