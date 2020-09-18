terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.14.0"
    }
  }

  required_version = "~> 0.13.3"
}
