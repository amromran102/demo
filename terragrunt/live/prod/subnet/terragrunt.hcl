include {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = ["../resource-group", "../vnet"]
}

terraform {
  source = "../../../terraform-modules/subnet"
}

inputs = {
  name                 = "prod-subnet"
  resource_group_name  = "my-prod-rg"
  virtual_network_name = "prod-vnet"
  address_prefixes     = ["10.42.1.0/24"]
}
