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

sudo apt-get install -y -q fabric

environment=$1

orig_dir=`pwd`
cd /vagrant/bootstrap/
fab --linewise $environment bootstrap
cd $orig_dir

echo `date` > /etc/akvo_provisioned

set_nameserver
