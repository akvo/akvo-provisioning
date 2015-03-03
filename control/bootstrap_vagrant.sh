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

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

sudo apt-get install -yq fabric

environment=$1

orig_dir=`pwd`
ohno=0
cd /vagrant/bootstrap/
ip=`ifconfig eth1 | grep 'inet addr' | awk -F: '{print $2}' | awk '{print $1}'`
fab -a -k --linewise --hosts=$ip on_environment:$environment bootstrap || ohno=1
cd $orig_dir

if [ $ohno -eq 1 ]
then
    exit 1
fi

set_nameserver
echo `date` > /etc/akvo_provisioned

