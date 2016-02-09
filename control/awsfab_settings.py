# AWS Fabric settings
# ===================
#
# To use the AWS-specific Fabric tasks, you **must** have an AWS credentials
# file in your home directory at $HOME/.aws/credentials

DEFAULT_REGION = "eu-west-1"
DEFAULT_SECURITY_GROUP = "default"

images = {"ubuntu-14.04-lts": "ami-f95ef58a"}

EC2_LAUNCH_CONFIGS = {}
