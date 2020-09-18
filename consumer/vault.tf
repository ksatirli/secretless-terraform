# see https://registry.terraform.io/providers/hashicorp/vault/2.14.0/ for more information
provider "vault" {
  # Vault configuration is recommended to be set via environment variables
  # see https://registry.terraform.io/providers/hashicorp/vault/2.14.0/docs#provider-arguments for more information
}

# see https://registry.terraform.io/providers/hashicorp/vault/2.14.0/docs/data-sources/generic_secret for more information
data "vault_generic_secret" "aws_db_instance" {
  # retrieve version 1 of the `aws_db_instance` secret
  path    = "secret/aws_db_instance"
  version = 1
}
