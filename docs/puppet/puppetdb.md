# PuppetDB

[PuppetDB](https://docs.puppetlabs.com/puppetdb/latest/) is used as the centralised "facts" store. Each server submits its configuration to PuppetDB, which means it is then available to other servers to query. This allows exported resources to work: machine A and machine B can specify that they needs a databases by registering that fact in PuppetDB. The machine running the database server can query PuppetDB to find out what other services want a database.

This means that the order of running puppet is important. For example, let's say that we are adding a new service to machine X, and the database server is running on machine Y. Puppet must first be run on X (to register that the database is needed) and then afterwards on Y (to create the database now that it is registered).

With the fabric scripts, the ordering is fairly random, so it's usually simpler just to run the puppet provisioning twice.

There is one single PuppetDB instance for every environment - this allows environments to share configuration such as host keys or ssh keys (useful for deployments for example). This instance lives on the `admin` environment.

Each vagrant development box has its own PuppetDB install, in order to make the vagrant box a completely independent environment.

## SSL Configuration

Puppet refuses to connect to PuppetDB except via SSL. Therefore we use [nginx to proxy](../../puppet/modules/puppetdb/templates/puppetdb-nginx.conf.erb) PuppetDB and serve it using an SSL certificate we create ourselves. There is an 'akvo-ops' certificate authority created for this purpose which is used for self-signing the server certificate.

Additionally, we don't want to allow access to PuppetDB to the open internet because it contains all of our sensitive data. However we can't simply use the firewall to restrict it to connections from our machines, because the firewall is managed using PuppetDB, so there is a chicken-and-egg problem. Therefore, we use SSL client certificates instead. During bootstrapping, [a client certificate is created](../../control/fabfile.py#L136) for the machine which will allow access to PuppetDB. 

### Creating a Certificate Authority

To create a new Certificate Authority:

    openssl req -sha256 -new -nodes -newkey rsa:4096 -x509 -days 365 \
    	-keyout ca.key -out ca.crt

The FQDN value should be set to `<environment>.akvo-ops.org`.

### Creating a Server Certificate for PuppetDB

First generate a key for the server:

    openssl genrsa -out server.key 4096

Generate a certificate signing request:

    openssl req -new -key server.key -out server.csr

The FQDN should be `puppetdb.<environment>.akvo-ops.org`.

Now create a certificate using the certificate authority created above:

    openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAKey ca.key \
    	-set_serial 01 -out server.crt 
    
You can now delete the CSR.

### Creating a Client Certificate for a Node

First create the client key:

    openssl genrsa -out client.key 4096
    
Create a signing request for the client key:
    
    openssl req -new -key client.key -out client.csr

The FQDN should be `<nodename>.<environment>.akvo-ops.org`.

Now sign the key using the certificate authority from above:

    openssl x509 -req -days 365 -in client.csr \
    	-CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt
    	
You can now delete the CSR.

