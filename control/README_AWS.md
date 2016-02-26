# AWS EC2 Instances

Please make sure you have the Python Boto3 library installed:

```shell
pip install --upgrade boto3
```

## Basic operations

### Create an EC2 instance

```shell
fab ec2_create_instance:<name>
```

### Create and attach an encrypted EBS volume to an instance

To create a 100Gb encrypted volume:

``` shell
fab ec2_create_volume:<name>,<size>
```

`<name>` should be a unique name tag, the same name should be used when creating
instances and volumes that belong together. `<size>` should be an integer value
representing the desired size of the volume in gigabytes.

Note that you may need to wait a minute or so before attaching a newly-created
volume to an instance. You may get an error that the volume is not yet
available.

To create a new encrypted EBS volume and attach it to an instance:

``` shell
fab ec2_attach_volume:<name>
```

`<name>` is the unique name given to both the instance and the volume when
you created them. The volume will be attached at `/dev/xvdf`. This is currently
not configurable.
