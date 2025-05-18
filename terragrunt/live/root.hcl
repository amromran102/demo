# Centralized remote state configuration
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "my-state-rg"
    storage_account_name = "mydemoterraformstate"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}
