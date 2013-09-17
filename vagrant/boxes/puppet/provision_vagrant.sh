#!/bin/bash

if [ -e /etc/localdev_puppet_provisioned ]
then
    echo "Already bootstrapped, so nothing to do"
    exit 0
fi
