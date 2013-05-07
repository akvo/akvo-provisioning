#!/bin/bash

# find out where we are relative to this script
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# help function
function show_help() {
    echo
    echo "Usage: bootstrap.sh [options] <target_host>"
    echo
    echo "Options:"
    echo "  -h                    show this help message and exit"
    echo "  -u USERNAME           the user to ssh into the target host as; defaults to root"
    echo
    exit 0
}


# check to see if we have fabric available
function check_for_fabric() {
    command -v fab >/dev/null 2>&1 || {
        echo >&2 "Bootstrapping a node requires fabric to be installed on your local machine.";
        echo >&2 "You can install it with 'pip install fabric'.";
        exit 1;
    }
}


# parse the arguments
OPTIND=1         # Reset in case getopts has been used previously in the shell.

user='root'

while getopts "h?vu:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    u)  user=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))


# make sure we have our dependencies
check_for_fabric


# figure out where we want to bootstrap
if [ -z $1 ];
then
    echo "The target node hostname must be specified"
    show_help
    exit 1
fi


# run fabric to bootstrap the node!
fab --fabfile=fabfile.py --user=$user --hosts=$target_host bootstrap


# install puppet apt repo
# install puppet 3+
# install facter
# install puppet modules
#    stdlib
# install facter plugin
# install role facts