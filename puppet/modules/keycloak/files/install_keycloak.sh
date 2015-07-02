#!/bin/bash
set -e

#fetch release archive (too big for GitHub)
RELEASE=keycloak-1.3.1.Final.tar.gz

wget --no-clobber http://files.support.akvo-ops.org/keycloak/$RELEASE

#unpack release zipfile, creating the app tree
gunzip -c $RELEASE | tar xvf - 

#save some disk space
rm $RELEASE

#if we make it this far, we succeeded, so prevent another run
touch .installed
