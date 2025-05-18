include {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = ["../resource-group"]
}

terraform {
  source = "../../../terraform-modules/nsg"
}

inputs = {
  name                = "prod-nsg"
  location            = "eastus"
  resource_group_name = "my-prod-rg"
}
