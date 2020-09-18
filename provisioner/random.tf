# see https://registry.terraform.io/providers/hashicorp/random/2.3.0 for more information
provider "random" {}

# see https://registry.terraform.io/providers/hashicorp/random/2.3.0/docs/resources/password for more information
resource "random_password" "instance_password" {
  length  = 16
  special = true
}

# outputting a password is NOT best practice, it is done here to illustrate the value
# outputting sensitive values
output "instance_password" {
  description = "randomly generated value of `instance_password`"
  value       = random_password.instance_password.result
}
