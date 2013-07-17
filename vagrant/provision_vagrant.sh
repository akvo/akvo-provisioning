#!/bin/bash

if [ -e /etc/localdev_rsr_provisioned ]
then
    echo "Already bootstrapped, so nothing to do"
    #exit 0
fi
