akvo-provisioning
=================

Server and development environment provisioning data and configurations


Terminology
---

### Environment

An environment is a collection of servers which, as a whole, represent a complete system. For example, the 'live' system would include all services necessary to serve all of the pieces of the Akvo infrastructure to actual users. 'dev' would be a set of servers for running test copies of our services, 'opstest' is used for testing configuration and 'localdev' means a Vagrant VM.

### Role

A role is a specific set of responsibilities. For example, the `management` role is all of the plumbing required to get puppet working, such as the `puppetdb` service. The `monitoring` role is the central server running monitoring tools such as `munin`. The `rsr` role is a server running the Django-based RSR app and associated infrastructure such as `nginx`.

### Node

A node is an individual machine in an environment. A node has one or more roles.

Roles
---

### Basic

The `basic` role is the minimal setup required to further configure this node. It is essentially bootstrapping further once the initial basic bootstrap scripts are finished.

### Management

There are some centralised services such as `puppetdb` which are required across the entire environment. These are provided by the management server. Note: a management node is required before any other nodes can be bootstrapped, as they will to contact their management node.

### Monitor

The `monitor` role is for the node which will run all of the monitoring tools designed to keep track of the performance of the rest of the environment nodes.

### Database

This node will run the databases required by the other systems. Currently, it will run both postgres and mysql.

### RSR

This node will run the `akvo-rsr` Django application. Currently there is no loadbalancing.


Running a Development Environment
---

Local development environments, built using [Vagrant](http://vagrantup.com), are stored in this repository also, in `vagrant/localdev/*`. For specific instructions for each environment, see the README either in the subdirectory in this repository, or in the repostiory of the relevant project.

To run the local puppet test environment, simply `cd` into `vagrant/localdev/puppet` and run `vagrant up` and similar.

For other test environments, this repository is included as a submodule.


Manipulating an Environment
---

Manipulation of environments - such as updating puppet config, changing roles for machines etc, is done through [fabric](http://fabfile.org). The fabfile is located at `environments/fabfile.py`.

You must first specify an environment before any commands. You can either pass in the name of an environment such as 'opstest', or point it to a custom `JSON` environment configuration file (see below for the definition of these files):

```
fab on_environment:opstest bootstrap
``` 
```
fab on_environment:/path/to/my/env.json update_config
```


Environment Configuration
---

Environment configuration takes the form of a `JSON` file. The standard ones are stored in `environments/config` folder.

NOTE: Currently, if there are problems in the file such as missing fields or incorrect types, things will simply break. There is no validation. So be careful when creating a file.

Example configuration, from `carltest.json`:

```
{
    "name": "carltest",

    "machine_type": "ec2",
    "base_domain": "akvotest.carlcrowder.com",

    "bootstrap_key_filename": "~/.ssh/ec2-test-instance.pem",
    "bootstrap_username": "ubuntu",

    "puppet_branch": "develop",

    "nodes": {
        "ec2-54-224-119-4.compute-1.amazonaws.com": {
           "roles": ["management"],
            "order": 0
        },
        "ec2-50-17-50-212.compute-1.amazonaws.com": {
            "roles": ["monitor"],
            "order": 10
        },
        "ec2-54-224-65-148.compute-1.amazonaws.com": {
            "roles": ["database"],
            "order": 20
        },
        "ec2-107-20-19-207.compute-1.amazonaws.com": {
            "roles": ["rsr"],
            "order": 30
        }
    }
}
```

### Required Fields

###### `name`: 

The name of the environment. Mostly for monitoring and reporting.

###### `base_domain`:

An environment is expected to run entirely as subdomain of some other domain, for example, all `opstest` services are `<something>.opstest.akvotest.org`. This is because the subdomain is delegated to a DNS server on the environment, allowing dynamic updating of the service locations within the environment. This base domain is the 

###### `nodes`:

A map of hostname to configuration for that node. Currently the only important configuration is the list of roles that the node will have (see above). You can also optionally specify an `order` parameter, to force a specific execution order for fabric to run through each node. 

### Optional Fields

###### `machine_type`:

The type of machine the system will run on. Values of `vagrant` and `ec2` will add some additional behaviour specific to those types; a value of `generic` will do nothing extra. The default value is `generic`.

###### `bootstrap_username`, `bootstrap_password`, `bootstrap_key_filename`:

When bootstrapping, the empty machines will require credentials. They are provided using these three settings. The default username is `root`. You can use an ssh ident file by setting it as the value of `bootstrap_key_filename`, or use standard password auth via `bootstrap_password`. If both the password and identity file are omitted, you will be prompted for a password.

###### `puppet_branch`:

For (non-local) environments, the nodes will have a local checkout of the `akvo-provisioning` repository. By default, they will checkout the `master` branch, but you can override this here.
