#!/bin/bash
if [ "$(whoami)" != "root" ]
then
    echo >&2 "This script must be run as root"
    exit 1
fi

MODULEPATH=/puppet/checkout/puppet/modules:/puppet/checkout/puppet/ext:/etc/puppet/modules:/usr/share/puppet/modules
puppet apply --parser future --modulepath=$MODULEPATH --verbose /puppet/checkout/puppet/manifests/site.pp

exit $?
