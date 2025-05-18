terraform {
  backend "azurerm" {}
}

# AKS module main.tf
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.vm_size
    os_disk_type    = "Managed"
    os_disk_size_gb = 30
    vnet_subnet_id  = var.vnet_subnet_id
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    dns_service_ip = var.dns_service_ip
    service_cidr   = var.service_cidr
  }
  tags = {
    created_by = "terraform"
  }
}
