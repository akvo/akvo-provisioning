# AWS EC2 Instances README

## Basic operations

### Create an instance

``` shell
awsfab ec2_launch_instance:<instance_name>
```

You will be prompted for what instance type you would like to create.
Additional instance types can be added to `awsfab_settings.py` should they be
required.

### List instances

``` shell
awsfab ec2_list_instances
```

### Login to an instance

``` shell
awsfab -E <instance_name> ec2_login
```

## Akvo-specific operations

### Create and attach an encrypted EBS volume to an instance

To create a 100Gb encrypted volume:

``` shell
awsfab ec2_create_volume:100
```

Note that you may need to wait a minute or so before attaching a newly-created
volume to an instance. You may get an error that the volume is not yet
available.

To attach a volume to an instance:

``` shell
awsfab ec2_attach_volume:<volume_id>,<instance_id>
```
