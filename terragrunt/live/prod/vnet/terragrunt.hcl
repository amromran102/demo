include {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = ["../resource-group"]
}

terraform {
  source = "../../../terraform-modules/vnet"
}

inputs = {
  name                = "prod-vnet"
  address_space       = ["10.42.0.0/20"]
  location            = "eastus"
  resource_group_name = "my-prod-rg"
}
