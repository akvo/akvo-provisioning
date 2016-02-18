from helpers import merge_configs

# AWS Fabric settings
# ===================
#
# To use the AWS-specific Fabric tasks, you **must** have an AWS credentials
# file in your home directory at $HOME/.aws/credentials

DEFAULT_REGION = "eu-west-1"
DEFAULT_AVAILABILITY_ZONE = "c"

# Common config
# -------------
# A dictionary of configuration options common to all instance types
common_config = {
    "ami": "ami-f95ef58a",
    "availability_zone": DEFAULT_AVAILABILITY_ZONE,
    "key_name": "devops",
    "region": DEFAULT_REGION,
    "security_groups": ["default"],
    "tags": {
        "awsfab-ssh-user": "ubuntu"
    }
}

# Instance configs
# ----------------
# See https://aws.amazon.com/ec2/instance-types/ for more information about all
# the available instance types
configs = {
    "t2.micro": {
        "description": "Ubuntu 14.04LTS on a t2.micro instance",
        "instance_type": "t2.micro"
    },
    "t2.small": {
        "description": "Ubuntu 14.04LTS on a t2.small instance",
        "instance_type": "t2.small"
    },
    "t2.medium": {
        "description": "Ubuntu 14.04LTS on a t2.medium instance",
        "instance_type": "t2.medium"
    },
    "t2.large": {
        "description": "Ubuntu 14.04LTS on a t2.large instance",
        "instance_type": "t2.large"
    }
}

EC2_LAUNCH_CONFIGS = {k: merge_configs(common_config, v) for k, v in configs.iteritems()}
