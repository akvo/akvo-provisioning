define psql::db ( $password ) {

    postgresql::db { $name:
      user          => $name,
      password      => $password,
      grant         => 'all',
    }

}