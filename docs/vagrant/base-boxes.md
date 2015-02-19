# Development and Base Boxes

[testlink](../../vagrant/boxes/rsr-dev-base)

There are development Vagrant machines for various codebases (currently akvo-rsr and akvo-web). The use configuration which is as similar as possible to live machines - for example, code runs behind Nginx and the firewall is installed. This allows us to test code against the environment and situation it will run in on the production servers.

To prevent having to build and install huge amounts of services each time someone starts developing, we have base boxes, which are as much as possible the complete development box with a few "spaces" which can be filled in by a local checkout of code.


## How to build a base-box

The following instructions refer to the RSR development base box but there is no significant difference for other base boxes.

1. Check out akvo-provisioning and akvo-rsr repositories
1. cd into `akvo-provisioning/vagrant/boxes/rsr-dev-base`
1. Create the base box using `vagrant up`
   * This builds with the puppet config that you have checked out. This should typically be the develop branch but if you want to include some new feature, simply change to that branch in the `akvo-provisioning` repository.
   * Make a cup of tea, this will take a while as it downloads and installs lots of things.
   * You may see lots of messages like this, but it's nothing to worry about - it just takes PuppetDB a long time to start up:
   
		```   
       [192.168.50.101] sudo: wget --no-check-certificate --private-key=/var/lib/puppet/ssl/private_keys/rsr1.localdev.akvo.org.pem --certificate=/var/lib/puppet/ssl/certs/rsr1.localdev.akvo.org.pem --server-response https://puppetdb 2>&1 | awk '/^  HTTP/{print $2}'
       [192.168.50.101] out: 404
		```

1. Make sure the box seems to work.
   * rsr not installed, so just make sure things like postgres are installed and running and that `/var/akvo/rsr` exists.
   
1. Now create the base box file: 

      ```vagrant package --output rsr-base-box-<the_date>.box```
      
1. At this point you can verify it works before uploading it by adjusting the akvo-rsr `VagrantFile`:
   * cd akvo-rsr
   * change the vagrant file URL to be `file://path/to/the/box.box`
   * change te box name in the VagrantFile (or it'll use the one you already have downloaded)
   * see if RSR works
   * undo the change
   
1. If everything is working you can upload it to `files.support.akvo-ops.org` and place it in the `/srv/fileserver` directory.
1. Update the RSR VagrantFile to point to the new base-box, commit and push!