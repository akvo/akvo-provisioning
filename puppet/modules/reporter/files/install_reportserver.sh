#!/bin/bash
set -e

#fetch release zipfile (Approx 200MB; too big for GitHub)
#RELEASE="RS2.2.1-5602-reportserver.zip"
#2.0 is actually more recent than 2.2 (.0 means special build)
RELEASE=RS2.2.0-5692-2015-06-07-17-36-58-reportserver.zip
PATCH1=org.eclipse.birt.runtime-4.4.1.jar.patch0

wget --no-clobber http://files.support.akvo-ops.org/reportserver/$RELEASE
wget --no-clobber http://files.support.akvo-ops.org/reportserver/$PATCH1

#unpack release zipfile, creating the app tree
unzip $RELEASE

#overwrite patched jar files
cp $PATCH1 WEB-INF/lib/org.eclipse.birt.runtime-4.4.1.jar

#save some disk space
#rm $RELEASE
rm $PATCH1

#if we make it this far, we succeeded, so prevent another run
touch .installed
