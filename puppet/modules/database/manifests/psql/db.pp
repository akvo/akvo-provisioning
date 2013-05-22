define database::psql::db ( $password ) {

    notice("postgresql database ${name}")

    postgresql::db { $name:
      user          => $name,
      password      => $password,
      grant         => 'all',
    }

}