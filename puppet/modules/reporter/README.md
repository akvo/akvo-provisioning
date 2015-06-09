reporter
========

Sets up a Datenwerke ReportServer instance


## Prerequisites
The Reportserver distribution zipfile must be available at http://files.support.akvo-ops.org/reportserver/ 

## Bootstrapping
 Several packages require libssl, which needs a postinstall reboot, so the server will probably need to be rebooted before working properly.
You will see a *** System restart required *** message when logging into the server. Believe it.

## Crypto parameters
Config will need three crypto parameters; they are used to hash passwords, and
If these are the same for test and live servers, the database can be just copied and accounts will continue to work the same

## Going live
These are the steps user stellan took to transfer a database from the test to the live server:

test: pg_dump -h psql -U reportserver --file=rs220.psql --clean reportserver
# password is in https://github.com/akvo/akvo-config/blob/master/config/envs/test/test4.test.akvo-ops.org.json

home: scp stellan@reporting.test.akvo-ops.org:rs220.psql rs220.psql
home: scp rs220.psql stellan@reporting.live.akvo-ops.org:rs220.psql

live: psql -h psql -U reportserver --file=rs220.psql reportserver
# password is in https://github.com/akvo/akvo-config/blob/master/config/envs/live/live8.live.akvo-ops.org.json

There will be six messages like this at the end, generally harmless:
 psql:rs220.psql:95938: ERROR:  must be member of role "postgres"



## Todo
The name of the reportserver distribution occurs in two places:
* install_reportserver.sh, where the zipfile is fetched from the support webserver
* populate_psql_db.sh(.erb), in the name of the db init script