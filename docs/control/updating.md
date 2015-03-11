# Updating Configuration on Servers

The [fabfile.py](../../control/fabfile.py) is the main entry point for updating servers, although what it does is very simply.

Each server has a script at `/puppet/bin/apply.sh` which will run puppet using the current configuration on the machine.

The fabric script simply updates the checkout of the `akvo-provisioning` repository on the machine then runs the `apply.sh` script.

Note that each environment uses a specific branch of `akvo-provisioning`, which is defined in the environment manifest (`<envname>/config.json` in `akvo-config`). This branch is `master` for live machines and generally `develop` for everything else, although sometimes it is useful to use a work-in-progress feature branch.

If you make changes to `akvo-provisioning`, you will need to push them to GitHub before you can apply them on the servers.

However your *local* `akvo-config` checkout will be used, so if you have local changes which are not checked in, they will still get picked up. (This could be potentially improved as it means that two people could use conflicting local configuration without realising).

To update all servers in an environment:

    fab on_environment:<envname> update_config
    
There are also some shortcuts - for example, the following are equivalent:

    fab test up
    fab on_environment:test update_config
    
This will run the provisioning one one machine at a time, but you can also use the `-P` flag to have fabric connect to each machine simoultaneously:

    fab test up -P