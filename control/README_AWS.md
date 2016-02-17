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

To attach a 100Gb encrypted volume to instance `<instance_name>`:

``` shell
awsfab -E <instance_name> ec2_attach_encrypted_volume 100
```
