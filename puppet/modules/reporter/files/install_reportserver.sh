#!/bin/bash
set -e

#fetch release zipfile (Approx 200MB; too big for GitHub)
#RELEASE="RS2.2.1-5602-reportserver.zip"
RELEASE=RS2.2.0-5654-2015-04-01-11-00-17-reportserver.zip
#next version: RELEASE="RS2.2.2-5639-reportserver.zip"
wget http://files.support.akvo-ops.org/reportserver/$RELEASE

#unpack release zipfile, creating the app tree
unzip $RELEASE

#overwrite patched jar files
#cp rsbirt.jar.patch2 WEB-INF/lib/rsbirt.jar
#cp rsbase.jar.patch2 WEB-INF/lib/rsbase.jar
#cp rssaiku.jar.patch3 WEB-INF/lib/rssaiku.jar

#save some disk space
#rm $RELEASE

#if we make it this far, we succeeded, so prevent another run
touch .installed
