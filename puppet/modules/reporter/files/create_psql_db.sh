#!/bin/bash
#exit if anything fails
set -e
#todo: make from template with parameters for db username, password and server

#create db user in postgresql
#now uses database::psql::db class
#sudo -u postgres psql <<EOF
#create user foo encrypted password 'bar';
#create database reportserver with encoding 'UTF8' TEMPLATE template0 owner foo;
#EOF

#Connect to new db, using IP socket so password auth is allowed:
# This works on 9.4 but not on 9.1:
# psql --dbname=postgresql://reportserver:bar@psql/reportserver --file=ddl/reportserver-RS2.2.1-5602-schema-PostgreSQL_CREATE.sql
export PGPASSWORD=bar
psql --host=psql --username=reportserver --file=ddl/reportserver-RS2.2.1-5602-schema-PostgreSQL_CREATE.sql reportserver 
#if we make it this far, we succeeded, so prevent another run. Need to be tomcat7.
touch .db_created
