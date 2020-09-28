# Secretless Terraform

> Write to and read from HashiCorp Vault, using the [Vault Provider for Terraform](https://registry.terraform.io/providers/hashicorp/vault/latest).

## Table of Contents

- [Secretless Terraform](#secretless-terraform)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Usage](#usage)
    - [Adding Secrets to Vault](#adding-secrets-to-vault)
    - [Reading Secrets from  Vault](#reading-secrets-from--vault)
  - [Notes](#notes)
  - [Author Information](#author-information)
  - [License](#license)

## Requirements

The code in this repository requires an unsealed, initialized Vault installation that can be accessed via the HTTP API.

## Usage

This codebase consists of two separate projects:

* `provisioner` showcases an implementation of the [Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest) to generate passwords and store them in a Vault installation
* `consumer` showcases an implementation of the [Vault Provider](https://registry.terraform.io/providers/hashicorp/vault/latest) to read secret data from a Vault installation and provision an AWS resource with it

To start, ensure you have access to an initialized and unsealed Vault installation and update the `VAULT_ADDR` environment variable to reflect the address of the Vault installation you want to use.

Next, initialize both directories by running `terraform init` to fetch any required provider plugins.

### Adding Secrets to Vault

In the `provisioner` directory, run `terraform plan -out="provisioner.tfplan"` to see the operations that can be carried out:

* Terraform will create a `random_password` resource (`instance_password`)
* Terraform will create a `vault_generic_secret` resource (`aws_db_instance`) and store it in Vault at `secret/aws_db_instance`

When you have inspected the resources and are satisfied, execute the plan by running `terraform apply "provisioner.tfplan"`.

At this point, you can inspect your Vault installation and find the newly created static secret.

### Reading Secrets from  Vault

In the `consumer` directory, run `terraform plan -out="consumer.tfplan"` to see the operations that can be carried out:

* Terraform will make a `GET` request to [icanhazip.com] using the `http` data source (`icanhazip`) to retrieve your IP address
* Terraform will create an AWS Security Group Rule and add your IP address (from the previous step) as an authorized caller
* Terraform will read the `secret/aws_db_instance` path from your Vault installation using a `vault_generic_secret` data source (`aws_db_instance`)
* Terraform will create an AWS RDS Instance (`secretless_terraform`) and set the instance password to the value of the `aws_db_instance` data source (from the previous step)

When you have inspected the resources and are satisfied, execute the plan by running `terraform apply "consumer.tfplan"`.

At this point, you can display the connection string for your MariaDB database using the [Terraform Output](https://www.terraform.io/docs/configuration/outputs.html) for `connection_string`:

```shell
terraform output connection_string
```

Please note: this string includes your RDS hostname, username, _and_ password. This is for demonstration purposes only and should _not_ be used in a _production_ setting.


## Notes

* For a guide on how to initialize and unseal Vault, see the [Deploy Vault](https://learn.hashicorp.com/tutorials/vault/getting-started-deploy#initializing-the-vault) tutorial on HashiCorp Learn.
* For a guide on how to enable a Secrets Engine in Vault, see the [Secrets Engines](https://learn.hashicorp.com/tutorials/vault/getting-started-secrets-engines#enable-a-secrets-engine) tutorial on HashiCorp Learn.

## Author Information

This repository is maintained by [Kerim Satirli](https://github.com/ksatirli) and [Rob Barnes](https://github.com/devops-rob).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
