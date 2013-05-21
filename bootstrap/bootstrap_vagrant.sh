#!/bin/bash

function set_nameserver {
    sed -i '/nameserver/d' /etc/resolv.conf
    echo 'nameserver 192.168.50.101' >> /etc/resolv.conf
}


if [ -e /etc/akvo_provisioned ]
then
    echo "Already bootstrapped, so nothing to do"
    set_nameserver
    exit 0
fi

roles=$@
echo "Including roles: $roles"

sudo apt-get install -y -q fabric

orig_dir=`pwd`
cd /vagrant/bootstrap/
./bootstrap.sh -A "--linewise --password=vagrant" -u vagrant localhost localdev $roles
cd $orig_dir


echo `date` > /etc/akvo_provisioned

set_nameserver