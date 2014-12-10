# Running and Testing

For testing the puppet manifests, there is [a Vagrant box](../../vagrant/boxes/puppet) configured.

To get up and running:

 * `cd` into the `vagrant/boxes/puppet` directory
 * Configure the list of roles in [puppet1.localdev.akvo.org.json](../../vagrant/boxes/puppet/puppet1.localdev.akvo.org.json).
   You can read more about [configuration and roles](../control/configuration)
 * `vagrant up` (note: you need [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed)
 * Wait for about 15 minutes. This process starts from a bare Ubuntu install and installs everything. This is essentially
   testing the [bootstrapping](../control/bootstrapping) process too!

Once the box is up and running, you can start changing manifests. It's better to start from a known good state,
as if the bootstrapping process fails, it's often in a strange unrecoverable state and you have to start over.

To apply the new puppet configuration on the vagrant box, as root, run `/puppet/bin/apply.sh`.


## Where are the Automated Tests?

There are no automated tests for the puppet modules right now, which is mainly because I haven't figured
out the best way to do it. Even the [documentation for rspec-puppet](http://rspec-puppet.com/tutorial/) says:

> At first glance, writing tests for your Puppet modules appears to be no more than simply duplicating your manifests in a different language and, for basic “package/file/service” modules, it is.

The best thing to move to in the future would be to use a continuous integration server to automatically update
some machine to the latest puppet manifests then run a suite of integration tests. This should include the tests
for each application that we run, such as RSR. There are no automated suites for our apps yet, however, so
no work has been done on automating tests for the akvo-provisioning repository.
