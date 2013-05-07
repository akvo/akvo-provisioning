#!/bin/bash

# first check to see if we have fabric available
command -v fab >/dev/null 2>&1 || {
    echo >&2 "Bootstrapping a node requires fabric to be installed on your local machine.";
    echo >&2 "You can install it with 'pip install fabric'.";
    exit 1;
}

# install puppet apt repo
# install puppet 3+
# install facter
# install puppet modules
#    stdlib
# install facter plugin
# install role facts