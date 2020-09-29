provider "aws" {
  region  = "eu-west-2"            # London, UK
  profile = "secretless_terraform" # use AWS CLI Profile "secretless_terraform"
}

# see https://registry.terraform.io/providers/hashicorp/aws/3.7.0/docs/data-sources/vpc for more information
data "aws_vpc" "secretless_terraform" {
  # grab the default (AWS-created) VPC
  default = true
}

# see https://registry.terraform.io/providers/hashicorp/aws/3.7.0/docs/resources/security_group for more information
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

# see https://registry.terraform.io/providers/hashicorp/aws/3.7.0/docs/resources/security_group_rule for more information
resource "aws_security_group_rule" "allow_mysql_from_self" {
  description = "Allow inbound MySQL access from local IP address"
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"

  # use the output of icanhazip.com, then clean it up using the
  # chomp function; see https://hashi.co/tf-chomp for information
  cidr_blocks       = ["${chomp(data.http.icanhazip.body)}/32"]
  security_group_id = aws_security_group.secretless_terraform.id
}

# see https://registry.terraform.io/providers/hashicorp/aws/3.7.0/docs/resources/db_instance for more information
resource "aws_db_instance" "secretless_terraform" {
  allocated_storage   = 20
  apply_immediately   = true
  engine              = "mariadb"
  instance_class      = "db.t2.micro"
  name                = "secretless_terraform"
  password            = data.vault_generic_secret.aws_db_instance.data["password"]
  publicly_accessible = true # making DB Instances publicly available is NOT best practice, it is done here for illustration purposes only
  skip_final_snapshot = true
  storage_type        = "gp2"
  username            = "devops"

  vpc_security_group_ids = [
    aws_security_group.secretless_terraform.id
  ]

  tags = {
    Name = "Terraform-managed instance for Secretless Terraform workshop"
  }
}

locals {
  # set up all required parts for the connection string
  # this is not strictly necessary, but allows for better readability
  connection_string_host = "--host=\"${aws_db_instance.secretless_terraform.address}\""
  connection_string_port = "--port=\"${aws_db_instance.secretless_terraform.port}\""
  connection_string_user = "--user=\"${aws_db_instance.secretless_terraform.username}\""
  connection_string_pass = "--password=\"${data.vault_generic_secret.aws_db_instance.data["password"]}\""
}

output "connection_string" {
  description = "connection string for the RDS Instance"
  value       = "mysql ${local.connection_string_host} ${local.connection_string_port} ${local.connection_string_user} ${local.connection_string_pass}"
}
