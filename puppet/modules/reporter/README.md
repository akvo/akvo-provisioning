reporter
========

Sets up a Datenwerke ReportServer instance

## Bootstrapping
 Several packages require libssl, which needs a postinstall reboot, so the server will probably need to be rebooted before working properly.
You will see a "*** System restart required ***" message when loggin into the server. Beleive it.

## Improvements
The name of the reportserver distribution occurs in two places:
* install_reportserver.sh, where the zipfile is fetched from the support webserver
* populate_psql_db.sh(.erb), in the name of the db init script