#!/usr/bin/env python

# note: this script is run inside the VM by vagrant
import os
import subprocess
import sys
import argparse
import time

# we need to make sure that the /vagrant/bootstrap directory is on our path,
# as when provisioning, vagrant will copy the boostrap_vagrant.py file into
# /tmp/ to execute it
sys.path.append('/vagrant/bootstrap/')

def _make_args():
    parser = argparse.ArgumentParser(description='Bootstraps an empty Vagrant VM')

    parser.add_argument('roles', metavar='ROLE', nargs='*',
                        help='A list of roles to include when bootstrapping')
    parser.add_argument('-n', '--nameserver', dest='nameserver_address',
                        default='192.168.50.101',
                        help="The DNS server to configure the system to use")

    return parser


def _set_nameserver(nameserver_address):
    new_contents = ['nameserver %s' % nameserver_address]
    with open('/etc/resolv.conf') as f:
        for line in f.readlines():
            if 'nameserver' not in line:
                new_contents.append(line)

    with open('/etc/resolv.conf', 'w') as f:
        f.write('\n'.join(new_contents))


def _already_provisioned():
    return os.path.exists('/etc/akvo_provisioned')


def _install_fabric():
    subprocess.check_call(['apt-get', 'install', '-y', '-q', 'fabric'])


args = _make_args().parse_args()

nameserver_address = args.nameserver_address
print "Using nameserver: %s" % nameserver_address


if _already_provisioned():
    print "Already bootstrapped, nothing to do"
    _set_nameserver(nameserver_address)
    #sys.exit(0)


roles = args.roles
if len(roles) > 0:
    print "Including roles: %s" % ', '.join(roles)
else:
    print "Including only basic setup"

# we need to have fabric installed
_install_fabric()

# now we use the generic control helper to bootstrap the node up to the point where
# puppet is installed, and also the management tools if this is a management node
import control
common_args = ['--fabric-args', '"--password=vagrant"',
               '--username', 'vagrant', '--directory', '/vagrant/bootstrap',
               'localhost', 'localdev']

command = 'bootstrap'
if 'management' in roles:
    roles.remove('management')
    command = 'bootstrap:management=1'
control.run(common_args + [command])

#  now we can add each of the roles which weren't already added
if len(roles) > 0:
    control.run(common_args + ['add_roles:%s' % ','.join(roles)] + ['update_config'])


# now set the nameserver to the one we just installed
_set_nameserver(nameserver_address)

# and make sure we don't provision the server again next time
with open('/etc/akvo_provisioned', 'w') as f:
    f.write(str(time.time()))