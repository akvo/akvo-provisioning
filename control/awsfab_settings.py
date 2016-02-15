# AWS Fabric settings
# ===================
#
# To use the AWS-specific Fabric tasks, you **must** have an AWS credentials
# file in your home directory at $HOME/.aws/credentials

_images = {"ubuntu-14.04-lts": "ami-f95ef58a"}

_common_config = {
    "ami": _images["ubuntu-14.04-lts"],
    "security_groups": ["default"],
    "region": "eu-west-1",
    "availability_zone": "c",
    "tags": {
        "awsfab-ssh-user": "ubuntu"
    }
}

_configs = {
    "t2.micro": {},
    "t2.small": {},
    "td.medium": {},
    "t2.large": {},
    "m4.large": {},
    "m4.xlarge": {},
    "m4.2xlarge": {},
    "m4.4xlarge": {},
    "m4.10xlarge": {}
}


def _merge(c):
    config = _common_config.copy()
    config.update(c)
    return config


EC2_LAUNCH_CONFIGS = {k: _merge(v) for k, v in _configs.iteritems()}
