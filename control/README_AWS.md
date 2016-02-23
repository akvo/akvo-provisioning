# AWS EC2 Instances

## Basic operations

### Create and attach an encrypted EBS volume to an instance

To create a 100Gb encrypted volume:

``` shell
fab ec2_create_volume:100
```

Note that you may need to wait a minute or so before attaching a newly-created
volume to an instance. You may get an error that the volume is not yet
available.

To attach a volume to an instance:

``` shell
fab ec2_attach_volume:<volume_id>,<instance_id>,<device_name>
```

The above options should be self-explanatory. `<device_name>` should be
something such as `/dev/sdh`.
