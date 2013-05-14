#!/bin/bash

if [ -e /etc/akvo_provisioned ]
then
    echo "Already bootstrapped, so nothing to do"
fi

roles=$@
echo "Including roles: $roles"

sudo apt-get install -y -q fabric

orig_dir=`pwd`
cd /vagrant/bootstrap/
./bootstrap.sh $extra_args -A "--linewise --password=vagrant" -u vagrant localhost localdev $roles
cd $orig_dir


echo `date` > /etc/akvo_provisioned
