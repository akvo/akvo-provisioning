import boto3


__all__ = ["get_instance_by_name"]


def get_instance_by_name(name):
    """
    Find an EC2 instance's ID from the given name tag
    """
    ec2 = boto3.client("ec2")
    filter_by_name = {"Name": "tag:Name", "Values": [name]}
    instances = ec2.describe_instances(Filters=[filter_by_name])
    instance_id = instances["Reservations"][0]["Instances"][0]["InstanceId"]
    return instance_id
