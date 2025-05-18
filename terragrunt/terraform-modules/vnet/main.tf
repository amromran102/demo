# VNet module main.tf
terraform {
  backend "azurerm" {}
}

resource "azurerm_virtual_network" "this" {
  name                = var.name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    created_by = "terraform"
  }
}
