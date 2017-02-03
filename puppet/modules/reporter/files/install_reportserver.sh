#!/bin/bash
set -e

#fetch release zipfile (Approx 220MB; too big for GitHub)
RELEASE=RS3.0.2-5855-2016-05-29-17-55-24-reportserver-ce.zip
#PATCH1=org.eclipse.birt.runtime-4.4.1.jar.patch0

wget --no-clobber http://files.support.akvo-ops.org/reportserver/$RELEASE
#wget --no-clobber http://files.support.akvo-ops.org/reportserver/$PATCH1

#unpack release zipfile, creating the app tree
unzip $RELEASE

#overwrite patched jar files
#cp $PATCH1 WEB-INF/lib/org.eclipse.birt.runtime-4.4.1.jar

#save some disk space
#rm $RELEASE
#rm $PATCH1

#if we make it this far, we succeeded, so prevent another run
touch .installed
