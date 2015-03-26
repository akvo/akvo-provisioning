#!/bin/bash
set -e

#fetch release zipfile (Approx 200MB)
wget http://files.support.akvo-ops.org/reportserver/RS2.2.1-5602-reportserver.zip

#unpack release zipfile, creating the app tree
unzip RS2.2.1-5602-reportserver.zip

#overwrite patched jar files
cp rsbirt.jar.patch2 WEB-INF/lib/rsbirt.jar
cp rsbase.jar.patch2 WEB-INF/lib/rsbase.jar
cp rssaiku.jar.patch3 WEB-INF/lib/rssaiku.jar

#save some disk space
rm RS2.2.1-5602-reportserver.zip

#if we make it this far, we succeeded, so prevent another run
touch .installed
