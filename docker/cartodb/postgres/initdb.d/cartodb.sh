#!/bin/bash
set -e

echo "----- Installing schema_triggers"
git clone git://github.com/CartoDB/pg_schema_triggers.git && \
    cd pg_schema_triggers && \
    make all install && \
    sed -i "/#shared_preload/a shared_preload_libraries = 'schema_triggers.so'" $PGDATA/postgresql.conf

echo "----- Installing cartodb extension v$V"
git clone --branch $V git://github.com/CartoDB/cartodb-postgresql.git && \
    cd cartodb-postgresql && \
    git checkout 189309e1a573ac8a91ee301b3a3d479eb54f9419 && \
    PGUSER=postgres make all install

echo "----- Creating required postgresql extensions"
POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-2.1.2;
sudo createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis
psql -U postgres -c "UPDATE pg_database SET datistemplate='true' \
          WHERE datname='template_postgis'"
psql -U postgres template_postgis -c \
    "CREATE EXTENSION postgis; \
     CREATE EXTENSION postgis_topology; \
     GRANT ALL ON geometry_columns TO PUBLIC; \
     GRANT ALL ON spatial_ref_sys TO PUBLIC;"
sudo ldconfig
psql -U postgres -c \
    "CREATE EXTENSION plpythonu; \
     CREATE EXTENSION schema_triggers; \
     CREATE EXTENSION postgis; \
     CREATE EXTENSION cartodb;"
