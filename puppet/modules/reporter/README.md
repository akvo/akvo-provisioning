reporter
========

Sets up a Datenwerke ReportServer instance


## Prerequisites
The Reportserver distribution zipfile must be available at http://files.support.akvo-ops.org/reportserver/ 

## Bootstrapping
 Several packages require libssl, which needs a postinstall reboot, so the server will probably need to be rebooted before working properly.
You will see a *** System restart required *** message when logging into the server. Believe it.

## Todo
The name of the reportserver distribution occurs in two places:
* install_reportserver.sh, where the zipfile is fetched from the support webserver
* populate_psql_db.sh(.erb), in the name of the db init script