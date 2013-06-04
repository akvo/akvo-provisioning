#!/bin/bash


# find out where we are relative to this script
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fabfile="$BASEDIR/fabfile.py"


# help function
function show_help() {
    echo
    echo "Usage: bootstrap.sh [options] <target_host> <environment> [roles...]"
    echo
    echo "Options:"
    echo "  -c COMMAND            run only the specified fabric task"
    echo "  -h                    show this help message and exit"
    echo "  -i SSH_IDENT          the ssh identity to use when logging in; otherwise password"
    echo "                        based access will be used"
    echo "  -u USERNAME           the user to ssh into the target host as; defaults to root"
    echo "  -M                    use this flag to create a management node, otherwise a basic"
    echo "                        node will be created"
    echo "  -v                    turn on verbose output (does not work with -c yet)"
    echo
    echo "Settings:"
    echo
    echo "The <environment> variable represents the 'type' of environment the server is running"
    echo "in. That is, if it is 'live', 'dev' or similar. Currently, valid values are:"
    echo
    echo "    live                For production machines running the live systems"
    echo "    localdev            For machines running for local development, probably Vagrant-based"
    echo "    opstest             Used for testing puppet configuration"
    echo
    echo "The [roles...] is an optional list of additional roles to be included. If not set, the node"
    echo "will have only the minimal configuration required. The add_role.sh script can then be used"
    echo "to add additional roles."
    exit 0
}


# parse the arguments
OPTIND=1         # Reset in case getopts has been used previously in the shell.

user='root'
verbose=0
extra_fabric_args=''
command='bootstrap'

while getopts "h?vu:i:c:A:" opt; do
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
    A)  extra_fabric_args=$OPTARG
        ;;
    v)  command='bootstrap:verbose=1'
        ;;
    esac
done

shift $((OPTIND-1))


# figure out where we want to bootstrap
if [ -z $1 ];
then
    echo >&2 "The target node hostname must be specified"
    show_help
    exit 1
fi
target_host="$1"
shift


# figure out what environment the node will have
if [ -z $1 ]
then
    echo >&2 "The environment for the node must be specified"
    show_help
    exit 1
fi
target_env="$1"
echo "opstest localdev live" | grep -e "\b$target_env\b" 2>&1 >/dev/null || {
    echo >&2 "The environment value '$target_env' is invalid"
    show_help
    exit 1
}
shift

roles=$@
roles=`echo "$roles" | sed -r 's/ /,/g'`
echo "Including roles: $roles"

# make sure we have our dependencies
command -v fab >/dev/null 2>&1 || {
    echo >&2 "Bootstrapping a node requires fabric to be installed on your local machine."
    echo >&2 "You can install it with 'pip install fabric'."
    exit 1
}


# set the base fabric command
runfab="fab $target_env with_roles:$roles --fabfile=$fabfile --user=$user --hosts=$target_host $extra_fabric_args "
if [ -n "$ssh_key_file" ]
then
    runfab="$runfab -i $ssh_key_file "
fi

# ensure we can ssh in and sudo
$runfab echo_test ||  {
    echo >&2 'Failed to connect to target node or to run sudo - check your access!'
    exit 1
}


# run fabric to bootstrap the node!
echo "Running fabric: $runfab $command"
$runfab $command

