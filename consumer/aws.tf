provider "aws" {
  region  = "eu-west-2"            # London, UK
  profile = "secretless_terraform" # use AWS CLI Profile "secretless_terraform"
}

# see https://registry.terraform.io/providers/hashicorp/aws/3.7.0/docs/data-sources/vpc for more information
data "aws_vpc" "secretless_terraform" {
  # grab the default (AWS-created) VPC
  default = true
}

resource "aws_security_group" "secretless_terraform" {
  # avoid setting the `name` attribute as the AWS API does not allow updating it

  # dynamically retrieve the ID of the VPC selected in the `aws_vpc` data source
  vpc_id = data.aws_vpc.secretless_terraform.id

  tags = {
    Name        = "Terraform-managed Security Group for Secretless Terraform"
    Description = "Manage inbound / outbound traffic for RDS Instance"
  }

  lifecycle {
    # ensure new security group is created and attached before
    # attempting to destroy the current, existing security group
    create_before_destroy = true
  }
}

