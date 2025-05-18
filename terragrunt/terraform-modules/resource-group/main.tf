terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags = {
    created_by = "terraform"
  }
}
