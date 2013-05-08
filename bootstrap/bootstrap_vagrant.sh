#!/bin/bash

orig_dir=`pwd`

cd /vagrant/bootstrap/
sudo apt-get install -y fabric
./bootstrap.sh -A "--linewise --password=vagrant" -u vagrant localdev localhost

cd $orig_dir

touch /etc/akvo_provisioned

# add the puppet apt repo
#sudo echo -e "deb http://apt.puppetlabs.com/ precise main\ndeb-src http://apt.puppetlabs.com/ precise main" >> /etc/apt/sources.list'
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 4BD6EC30'
#sudo apt-get update

# upgrade puppet
#sudo apt-get install -y puppet

# we need fabric and git too
#sudo apt-get install -y fabric git

# now figure out where we are so we know where the fabfile is
#FABFILE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/fabfile.py"

#echo $FABFILE
