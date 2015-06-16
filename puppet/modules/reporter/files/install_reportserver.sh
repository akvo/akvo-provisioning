#!/bin/bash
set -e

#fetch release zipfile (Approx 200MB; too big for GitHub)
#RELEASE="RS2.2.1-5602-reportserver.zip"
#2.0 is actually more recent than 2.2 (.0 means special build)
RELEASE=RS2.2.0-5692-2015-06-07-17-36-58-reportserver.zip

wget --no-clobber http://files.support.akvo-ops.org/reportserver/$RELEASE

#unpack release zipfile, creating the app tree
unzip $RELEASE

#overwrite patched jar files (only for 2.1)
#cp rsbirt.jar.patch2 WEB-INF/lib/rsbirt.jar
#cp rsbase.jar.patch2 WEB-INF/lib/rsbase.jar

#save some disk space
#rm $RELEASE

#if we make it this far, we succeeded, so prevent another run
touch .installed
