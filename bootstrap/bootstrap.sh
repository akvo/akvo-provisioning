#!/bin/bash

# find out where we are relative to this script
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# help function
function show_help() {
    echo
    echo "Usage: bootstrap.sh [options] <target_host>"
    echo
    echo "Options:"
    echo "  -c COMMAND            run only the specified fabric task"
    echo "  -h                    show this help message and exit"
    echo "  -i SSH_IDENT          the ssh identity to use when logging in; otherwise password"
    echo "                        based access will be used"
    echo "  -u USERNAME           the user to ssh into the target host as; defaults to root"
    echo "  -v                    turn on verbose output"
    echo
    exit 0
}


# parse the arguments
OPTIND=1         # Reset in case getopts has been used previously in the shell.

user='root'
verbose=0
command='bootstrap'

while getopts "h?vu:i:c:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    u)  user=$OPTARG
        ;;
    i)  ssh_key_file=$OPTARG
        ;;
    c)  command=$OPTARG
        ;;
    v)  verbose=1
    esac
done

shift $((OPTIND-1))


# figure out where we want to bootstrap
if [ -z $1 ];
then
    echo "The target node hostname must be specified"
    show_help
    exit 1
fi
target_host="$1"


# make sure we have our dependencies
command -v fab >/dev/null 2>&1 || {
    echo >&2 "Bootstrapping a node requires fabric to be installed on your local machine."
    echo >&2 "You can install it with 'pip install fabric'."
    exit 1
}


# set the base fabric command
runfab="fab --fabfile=fabfile.py --user=$user --hosts=$target_host "
if [ -n "$ssh_key_file" ]
then
    runfab="$runfab -i $ssh_key_file "
fi


# ensure we can ssh in and sudo
$runfab echo_test >/dev/null 2>&1 ||  {
    echo >&2 'Failed to connect to target node or to run sudo - check your access!'
    exit 1
}


# run fabric to bootstrap the node!
$runfab $command


# install puppet apt repo
# install puppet 3+
# install facter
# install puppet modules
#    stdlib
# install facter plugin
# install role facts