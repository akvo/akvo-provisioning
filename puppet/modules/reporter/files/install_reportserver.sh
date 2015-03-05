#!/bin/bash

#fetch release zipfile (Approx 200MB)
wget http://files.support.akvo-ops.org/reportserver/RS2.2.1-5602-reportserver.zip

#unpack release zipfile
unzip RS2.2.1-5602-reportserver.zip

#configure DB connection. This file is unfortunately version-specific.
#TODO: make into template with DB connection parameters
cp persistence.xml WEB-INF/classes/META-INF/persistence.xml

#overwrite patched jar files
cp rsbirt.jar.patch2 WEB-INF/lib/rsbirt.jar
cp rsbase.jar.patch2 WEB-INF/lib/rsbase.jar
cp rssaiku.jar.patch3 WEB-INF/lib/rssaiku.jar

#if we make it this far, we succeeded, so prevent another run
touch .installed
