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
fab ec2_create_volume:<name>,100
```

Note that you may need to wait a minute or so before attaching a newly-created
volume to an instance. You may get an error that the volume is not yet
available.

To create a new encrypted EBS volume and attach it to an instance:

``` shell
fab ec2_attach_volume:<size>,<instance_name>,<device_name>
```

`<size>` should be an integer value representing the desired size of the volume
in gigabytes. `<device_name>` should be a Unix device name such as `/dev/sdh`.
