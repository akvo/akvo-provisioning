# -*- coding: utf-8 -*-

"""Helper functions for use in Fabric tasks."""

import boto3


__all__ = ["get_ec2_instance_by_name"]


def get_ec2_instance_by_name(name):
    """Find an EC2 instance's ID from the given name tag."""
    client = boto3.client("ec2")
    name_filter = {"Name": "tag:Name", "Values": [name.strip().lower()]}
    instances = client.describe_instances(Filters=[name_filter])
    reservations = instances["Reservations"]
    if len(reservations) == 1:
        instance_id = reservations[0]["Instances"][0]["InstanceId"]
        return instance_id
    return None
