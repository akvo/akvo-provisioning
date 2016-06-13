#!/usr/bin/env bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE lumen WITH PASSWORD 'password' CREATEDB LOGIN;
    CREATE DATABASE lumen
    WITH OWNER lumen
      TEMPLATE = template0
      ENCODING = 'UTF8'
      LC_COLLATE = 'en_US.UTF-8'
      LC_CTYPE = 'en_US.UTF-8';
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "lumen" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
EOSQL


psql -v ON_ERROR_STOP=1 --username "lumen" <<-EOSQL
    CREATE DATABASE lumen_tenant_1
    WITH OWNER = lumen
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';

    CREATE DATABASE lumen_tenant_2
    WITH OWNER = lumen
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';
EOSQL


psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "lumen_tenant_1" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "lumen_tenant_2" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
EOSQL
