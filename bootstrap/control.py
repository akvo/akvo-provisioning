#!/usr/bin/env python

import argparse
import subprocess
import sys
import os


def _make_args():
    epilog = """The <ENV> variable represents the 'type' of environment the server is running
in. That is, if it is 'live', 'dev' or similar. Currently, valid values are:

    live                For production machines running the live systems
    localdev            For machines running for local development, probably Vagrant-based
    opstest             Used for testing puppet configuration"""

    parser = argparse.ArgumentParser(description='Control a node in an Akvo environment.',
                                     epilog=epilog, formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('target_host', metavar='HOST',
                        help='The target node to control')
    parser.add_argument('environment', metavar='ENV',
                        help='The target environment')
    parser.add_argument('command', metavar='COMMAND', nargs='+',
                        help='The fabric command(s) to run')

    parser.add_argument('-i', '--ident', dest='identity_file',
                        help='The ssh identity to use when logging in; otherwise password based access will be used')
    parser.add_argument('-u', '--username', dest='username',
                        help='The user to ssh into the target host as; defaults to root')
    parser.add_argument('-A', '--fabric-args', dest='fabric_args',
                        help='Any additional arguments to pass into fabric')
    parser.add_argument('-d', '--directory',
                        help='The location of the bootstrap scripts, if not in the current directory')
    parser.add_argument('-c', '--ssh-config-file', dest='ssh_config',
                        help='The location of an OpenSSH style ssh config file')

    return parser

def run(args):
    parser = _make_args()
    args = parser.parse_args(args)

    if args.environment not in ('live', 'localdev', 'opstest', 'carltest'):
        print 'Environment %s not valid' % args.environment
        sys.exit(1)

    fabcmd = ['fab', '--linewise', '--hosts=%s' % args.target_host]
    if args.fabric_args:
        fabcmd += [args.fabric_args]
    if args.identity_file:
        fabcmd += ['-i', args.identity_file]
    if args.username:
        fabcmd += ['--user=%s' % args.username]
    if args.directory:
        fabcmd += ['--fabfile=%s' % os.path.join(args.directory, 'fabfile.py')]
    if args.ssh_config:
        fabcmd += ['--ssh-config-path=%s' % args.ssh_config]

    fabcmd += [args.environment] + args.command
    fabcmd = ' '.join(fabcmd)

    print 'Executing fabric command: %s' % fabcmd
    proc = subprocess.Popen(args=fabcmd, shell=True, cwd=args.directory)
    proc.wait()


if __name__ == '__main__':
    run(sys.argv[1:])
