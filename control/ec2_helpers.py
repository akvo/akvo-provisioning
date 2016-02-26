import boto3


__all__ = ["get_resource_by_name"]


def get_resource_by_name(name, resource_type="instance"):
    """
    Find an EC2 resource's ID from the given name tag
    """
    ec2 = boto3.client("ec2")
    resource_type = resource_type.lower()
    filter_by_name = {"Name": "tag:Name", "Values": [name]}
    if resource_type == "instance":
        resources = ec2.describe_instances(Filters=[filter_by_name])
        resource_id = resources["Reservations"][0]["Instances"][0]["InstanceId"]
    elif resource_type == "volume":
        resources = ec2.describe_volumes(Filters=[filter_by_name])
        resource_id = resources["Volumes"][0]["VolumeId"]
    else:
        raise SyntaxError("Supported resource types are 'instance' and 'volume'!")
    return resource_id
