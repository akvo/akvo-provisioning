class users::carl { 

    user { 'carl':
        ensure   => 'present',
        home     => '/home/carl',
        shell    => '/bin/bash',
        groups   => ['ops'],
        password => '$6$w2FK/jnb$9KqSVzM1ha2rPMF8SfLayCIrnkqqyRSSSvVTPQEUTBa46Hd2AcoSDuyzsywWTyCpb7guoHn.on/08qJW1IhGJ.',
        require  => Group['ops']
    }
  
    group { 'carl':
        require => User['carl']
    }
  
    file { '/home/carl/':
        ensure => directory,
        owner => 'carl',
        group => 'carl',
        mode => 750,
        require => [ User['carl'], Group['carl'] ],
    }
  
    file { '/home/carl/.ssh':
        ensure => directory,
        owner => 'carl',
        group => 'carl',
        mode => 700,
        require => File['/home/carl/'],
    }
  
    file { '/home/carl/.ssh/authorized_keys':
        ensure => present,
        owner => 'carl',
        group => 'carl',
        mode => 600,
        require => File['/home/carl/.ssh'],
    }
  
    file { '/home/carl/.screenrc':
        ensure => present,
        owner => 'carl',
        group => 'carl',
        mode => 755,
        source => 'puppet:///modules/users/screenrc',
        require => File['/home/carl'],
    }

    ssh_authorized_key { "carl_key":
        ensure  => present,
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCV/jM2Jki7PZ/rQpqcJbVcAQtI5i6pZY5EkcdZuWvV3YQkkUpe6HcKJeQk+RyqieOSvjFyud7qIR6gBQ9bujOPMObdNG5lMMiycSRLKzijMOJAjfVNvOJiY4LDku+gygYNoCIlooCcZPcBc9AYzfO6uZ4NLRQHixuSdavaSeiA9jlY9gLjsHuqsIqKjPxQ5SpFfrg33nquEZBG4c/ch/Rz1un7pQDvzVlu0VIzX3nqsn0fuRZ5SCc7UGaDdiv/qRVUyVbapT1BNMbgDBg+WBcMJMsuHStoDjgzU7WcnjHiY2M/4EcoI61ELnH53lmblN3KXySpgkxZ8JQNJvUp/Zl1',
        type    => 'ssh-rsa',
        user    => 'carl',
        require => File['/home/carl/.ssh/authorized_keys']
    }



}
