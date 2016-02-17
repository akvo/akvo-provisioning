# AWS Fabric settings
# ===================
#
# To use the AWS-specific Fabric tasks, you **must** have an AWS credentials
# file in your home directory at $HOME/.aws/credentials


# Common configuration
# --------------------
# A dictionary of configuration options common to all instance types
_common_config = {
    "ami": "ami-f95ef58a",
    "key_name": "devops",
    "security_groups": ["default"],
    "region": "eu-west-1",
    "availability_zone": "c",
    "tags": {
        "awsfab-ssh-user": "ubuntu"
    }
}

# Instance configs
# ----------------
# See https://aws.amazon.com/ec2/instance-types/ for more information
_configs = {
    "t2.micro": {
        "description": "Ubuntu 14.04LTS on a t2.micro instance",
        "instance_type": "t2.micro",
    },
    "t2.small": {
        "description": "Ubuntu 14.04LTS on a t2.small instance",
        "instance_type": "t2.small",
    },
    "t2.medium": {
        "description": "Ubuntu 14.04LTS on a t2.medium instance",
        "instance_type": "t2.medium",
    },
    "t2.large": {
        "description": "Ubuntu 14.04LTS on a t2.large instance",
        "instance_type": "t2.large",
    }
}


def _merge(c):
    config = _common_config.copy()
    config.update(c)
    return config


EC2_LAUNCH_CONFIGS = {k: _merge(v) for k, v in _configs.iteritems()}
