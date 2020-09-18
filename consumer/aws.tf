provider "aws" {
  region  = "eu-west-2"            # London, UK
  profile = "secretless_terraform" # use AWS CLI Profile "secretless_terraform"
}

# see https://registry.terraform.io/providers/hashicorp/aws/3.7.0/docs/data-sources/vpc for more information
data "aws_vpc" "secretless_terraform" {
  # grab the default (AWS-created) VPC
  default = true
}

