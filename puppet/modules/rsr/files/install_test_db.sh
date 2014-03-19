#!/bin/bash

WORKDIR=/tmp/rsr-test-db/
DBZIP='http://files.support.akvo-ops.org/devdbs/rsr-test-db-small.zip'

rm -rfv $WORKDIR
mkdir $WORKDIR

cd $WORKDIR

curl $DBZIP > $WORKDIR/rsr-test-db.zip

unzip $WORKDIR/rsr-test-db.zip -d $WORKDIR

rm -rfv /var/akvo/rsr/mediaroot/db
cp -rv $WORKDIR/rsr-test-db/media/db /var/akvo/rsr/mediaroot/db
chown -R rsr.rsr /var/akvo/rsr/mediaroot/db

zcat $WORKDIR/rsr-test-db/rsr.sql.gz | mysql -u root -D rsr

rm -rfv $WORKDIR
