provider "http" {}

# see https://registry.terraform.io/providers/hashicorp/http/1.2.0/docs/data-sources/data_source for more information
data "http" "icanhazip" {
  # get your public IP address by querying ICHI
  # this value will be available in data.http.icanhazip.body
  url = "https://icanhazip.com/"
}
