terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.8.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "1.2.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "2.14.0"
    }
  }

  required_version = "~> 0.13.3"
}
