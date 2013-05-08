#!/bin/bash
MODULEPATH=/etc/puppet/modules:/usr/share/puppet/modules:/puppet/checkout/puppet/modules
sudo puppet apply --modulepath=$MODULEPATH --verbose /puppet/checkout/puppet/manifests/site.pp
