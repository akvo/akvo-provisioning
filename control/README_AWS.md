# AWS EC2 Instances

Please make sure you have the Python Boto3 library installed and that you have
appropriate AWS credentials configured in `$HOME/.aws/credentials`!

```shell
pip install --upgrade boto3
```

## ec2_create_instance

The syntax for this task is as follows:

```shell
fab ec2_create_instance:<name>,<instance_type>,<volume_size>
```

Here's an actual example:

```shell
fab ec2_create_instance:cartodb_db,t2.small,100
```

This command will create a `t2.small` EC2 instance with the name tag
`cartodb_db` with a 100GB encrypted EBS volume attached to it, mounted at
`/puppet`.
