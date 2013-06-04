#!/bin/bash

# find out where we are relative to this script
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fabfile="$BASEDIR/fabfile.py"
key="$BASEDIR/puppet.id_rsa"

$BASEDIR/control.sh -c "bootstrap" $@


