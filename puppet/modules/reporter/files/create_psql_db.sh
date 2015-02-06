#!/bin/bash

#create db user in postgresql
sudo -u postgres psql <<EOF
create user foo encrypted password 'bar';
create database reportserver with encoding 'UTF8' TEMPLATE template0 owner foo;
EOF

#Connect to new db, using IP socket so password auth is allowed:
 psql --dbname=postgresql://foo:bar@localhost/reportserver --file=ddl/reportserver-RS2.2.1-5602-schema-PostgreSQL_CREATE.sql
#if we make it this far, we succeeded, so prevent another run
touch .db_created
