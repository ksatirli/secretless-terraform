# see https://registry.terraform.io/providers/hashicorp/vault/2.14.0/ for more information
provider "vault" {
  # Vault configuration is recommended to be set via environment variables
  # see https://registry.terraform.io/providers/hashicorp/vault/2.14.0/docs#provider-arguments for more information
}

locals {
  # create a JSON-encoded local variable, using the result of the `random_password.instance_password` resource
  aws_instance_data = jsonencode({ "pass" : random_password.instance_password.result })
}

# see https://registry.terraform.io/providers/hashicorp/vault/2.14.0/docs/resources/generic_secret for more information
resource "vault_generic_secret" "aws_instance" {
  path      = "secret/aws_instance"
  data_json = local.aws_instance_data
}
