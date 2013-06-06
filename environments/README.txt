Akvo Node Bootstrapping
===

This directory contains the required scripts and files to bootstrap a completely empty new
server running Ubuntu 12.04 to a point where it can provision itself using puppet.


Requirements
---

1. Fabric
The initial setup requires fabric on your local machine. You can install this with:

    pip install fabric

See also http://docs.fabfile.org/


2. SSH access to the target
It also requires that you are able to ssh into the target machine as a user with sudo privileges,
or as the root user directly.


3. Ubuntu 12.04
This setup script and the puppet configuration assumes Ubuntu 12.04. While it may 'just work' on
newer/older versions of Ubuntu or other Debian systems, it's not expected to.


Usage
---

./bootstrap.sh