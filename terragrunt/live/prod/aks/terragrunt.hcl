include {
  path = find_in_parent_folders("root.hcl")
}

dependency "subnet" {
  config_path = "../subnet"
}

dependencies {
  paths = ["../resource-group", "../vnet", "../subnet"]
}

terraform {
  source = "../../../terraform-modules/aks"
}

inputs = {
  name                = "prod-aks"
  location            = "eastus"
  resource_group_name = "my-prod-rg"
  dns_prefix          = "prod-aks"
  node_count          = 3
  vm_size             = "Standard_B2ms"
  service_cidr        = "10.42.2.0/24"
  dns_service_ip      = "10.42.2.10"
  vnet_subnet_id      = dependency.subnet.outputs.id
}
