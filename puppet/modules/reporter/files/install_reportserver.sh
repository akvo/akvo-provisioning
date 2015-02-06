#!/bin/bash

#unpack release zipfile
unzip RS2.2.1-5602-reportserver.zip

#configure DB connection
cp persistence.xml WEB-INF/classes/META-INF/persistence.xml

#overwrite patched jar files
cp rsbirt.jar.patch2 WEB-INF/lib/rsbirt.jar
cp rsbase.jar.patch2 WEB-INF/lib/rsbase.jar

#if we make it this far, we succeeded, so prevent another run
touch .installed
