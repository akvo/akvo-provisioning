class users::carl { 

    users::basic { 'carl':
        role     => ['ops'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCV/jM2Jki7PZ/rQpqcJbVcAQtI5i6pZY5EkcdZuWvV3YQkkUpe6HcKJeQk+RyqieOSvjFyud7qIR6gBQ9bujOPMObdNG5lMMiycSRLKzijMOJAjfVNvOJiY4LDku+gygYNoCIlooCcZPcBc9AYzfO6uZ4NLRQHixuSdavaSeiA9jlY9gLjsHuqsIqKjPxQ5SpFfrg33nquEZBG4c/ch/Rz1un7pQDvzVlu0VIzX3nqsn0fuRZ5SCc7UGaDdiv/qRVUyVbapT1BNMbgDBg+WBcMJMsuHStoDjgzU7WcnjHiY2M/4EcoI61ELnH53lmblN3KXySpgkxZ8JQNJvUp/Zl1',
        htpasswd => '$apr1$Sqaty6NW$wQ3ZL/.HPzuoIX2BbJdtR/'
    }

    file { '/home/carl/.screenrc':
        ensure => present,
        owner => 'carl',
        group => 'carl',
        mode => 755,
        source => 'puppet:///modules/users/screenrc',
        require => File['/home/carl'],
    }

}
