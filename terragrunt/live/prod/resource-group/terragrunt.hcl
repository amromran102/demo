include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../terraform-modules/resource-group"
}

inputs = {
  name     = "my-prod-rg"
  location = "eastus"
}
