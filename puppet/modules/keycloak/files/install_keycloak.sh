#!/bin/bash
set -e

#fetch release archive (too big for GitHub)
RELEASE=keycloak-1.3.1.Final
RELEASEFILE=${RELEASE}.tar.gz

wget --no-clobber http://files.support.akvo-ops.org/keycloak/$RELEASE

#unpack release zipfile, creating the app tree
gunzip -c $RELEASEFILE | tar xvf - 

#save some disk space
rm $RELEASEFILE

#get the postgresql driver
mkdir -p /opt/keycloak/${RELEASE}/modules/system/layers/base/org/postgresql/jdbc/main
cd /opt/keycloak/${RELEASE}/modules/system/layers/base/org/postgresql/jdbc/main
curl -O http://central.maven.org/maven2/org/postgresql/postgresql/9.3-1102-jdbc3/postgresql-9.3-1102-jdbc3.jar


#if we make it this far, we succeeded, so prevent another run
touch .installed
