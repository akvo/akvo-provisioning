#!/bin/bash

if [ -e /etc/akvo_provisioned ]
then
    echo "Already bootstrapped, so nothing to do"
    exit 0
fi

sudo apt-get install -y -q fabric

$extra_args = ''
if [ $1 == '--include-management' ]
then
    $extra_args = '-M'
fi

orig_dir=`pwd`
cd /vagrant/bootstrap/
./bootstrap.sh $extra_args -A "--linewise --password=vagrant" -u vagrant localhost localdev
cd $orig_dir


echo `date` > /etc/akvo_provisioned
