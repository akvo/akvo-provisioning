#!/bin/bash
MODULEPATH=/puppet/checkout/puppet/modules:/etc/puppet/modules:/usr/share/puppet/modules
sudo puppet apply --modulepath=$MODULEPATH --verbose /puppet/checkout/puppet/manifests/site.pp
