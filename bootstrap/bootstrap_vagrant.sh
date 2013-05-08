#!/bin/bash

if [ -e /etc/akvo_provisioned ]
then
    echo "Already bootstrapped, so nothing to do"
    #exit 0
fi

sudo apt-get install -y -q fabric

orig_dir=`pwd`
cd /vagrant/bootstrap/
./bootstrap.sh -A "--linewise --password=vagrant" -u vagrant $1 localdev localhost
cd $orig_dir


echo `date` > /etc/akvo_provisioned
