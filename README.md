akvo-provisioning
=================

Server and development environment provisioning data and configurations


Terminology
===

Environment
---

An environment is a collection of servers which, as a whole, represent a complete system. For example, the 'live' system would include all services necessary to serve all of the pieces of the Akvo infrastructure to actual users. 'dev' would be a set of servers for running test copies of our services, 'opstest' is used for testing configuration and 'localdev' means a Vagrant VM.

Role
---
A role is a specific set of responsibilities. For example, the `management` role is all of the plumbing required to get puppet working, such as the `puppetdb` service. The `monitoring` role is the central server running monitoring tools such as `munin`. The `rsr` role is a server running the Django-based RSR app and associated infrastructure such as `nginx`.

Node
---
A node is an individual machine in an environment. A node has one or more roles

Roles
===

Basic
---
The `basic` role is the minimal setup required to further configure this node. It is essentially bootstrapping further once the initial basic bootstrap scripts are finished.

Management
---
There are some centralised services such as `puppetdb` which are required across the entire environment. These are provided by the management server. Note: a management node is required before any other nodes can be bootstrapped, as they will to contact their management node.

Monitor
---
The `monitor` role is for the node which will run all of the monitoring tools designed to keep track of the performance of the rest of the environment nodes.

Everything
---
This is a shorthand for testing; including this role will cause every other role to be included.

Environment Setup Instructions
===
* Ensure the correct config is in [TODO: set up heira and include info here]

* Create a subdomain, if one doesn't exist.

* Create a management node:
	* Run bootstrap.sh using the role 'management'

		```
		./bootstrap.sh management <environment> <address>
		```
		
* Create other required systems and roles; for example, add a monitoring server
	```
	./bootstrap.sh monitoring <environment> <address2>
	```
	
TODO: create an `addrole.sh` script; make bootstrap nodes only create basic or management roles.