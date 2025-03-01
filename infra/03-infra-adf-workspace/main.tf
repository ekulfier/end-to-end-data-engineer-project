# Resource Group 
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "data_factory" {
  source = "../modules/adf-workspace"

  count = var.adf_name != "" ? 1 : 0

  adf_name                   = var.adf_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  linked_resource_group_name = var.linked_resource_group_name
  storage_account_name       = var.storage_account_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}
