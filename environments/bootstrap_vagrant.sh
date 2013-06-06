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
ohno=0
cd /vagrant/bootstrap/
fab --linewise on_environment:$environment bootstrap || ohno=1
cd $orig_dir

set_nameserver

if [ $ohno -eq 1 ]
then
    exit 1
fi

echo `date` > /etc/akvo_provisioned

