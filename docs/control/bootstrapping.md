# Bootstrapping New Nodes

Bootstrapping is the process of going from a completely new server with a bare OS to being fully provisioned. There are two steps: first, installing certain required packages on the server such as git and puppet, creating [the client certificate for puppetdb](../puppet/puppetdb.md) and so on. This is as minimal as possible. 

The second step is the initial runs of puppet provisioning. This is done in two passes. The first pass installs enough packages and configuration to communicate with PuppetDB, and the second pass is then able to pull down facts from other servers to complete any configuration which depends on the state of other machines.

## Adding a New Server

Two changes need to be made to the [configuration files](../configuration.md). Firstly, the relevant environment manifest (`<envname>/config.json`) needs to be updated to include the new machine IP and nodename. 

Secondly, a new configuration file for the machine should be created in `config/envs/<envname>/<hostname>.json`. Although this is not necessary, it will almost always be useful. 

## The Bootstrapping Command

The [fabfile located in the control directory](../../control/fabfile.py) contains all of the directives required to bootstrap a node.

You need to specify the IP addresses of the new machines as a comma-separated list. This is to prevent the bootstrapping steps being run on machines which have already been provisioned. It is not destructive to run bootstrapping multiple times, but you may get odd failures, so it's better to simply avoid that situation in the first place. If setting up a complete new environment, you can omit the `--hosts` flag and all will be bootstrapped.

    fab on_environment:<env-name> bootstrap --hosts=<ip-of-new-machine>
    
Note that you should not use the `--parallel` / `-P` flag for this command, because when fabric runs multiple processes it is unable to accept passwords, which you will need to enter.
