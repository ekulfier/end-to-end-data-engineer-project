resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name_prefix
  location = var.resource_group_location
  tags     = var.tags
}

resource "random_password" "admin_password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  admin_password = try(random_password.admin_password[0].result, var.admin_password)
}

resource "azurerm_mssql_server" "server" {
  name                         = var.mssql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"
  tags                         = var.tags

  azuread_administrator {
    login_username = "SQL-Admins"
    object_id      = "87da8549-56b4-483c-877b-2e37cf637659"
  }
}

resource "azurerm_mssql_database" "db" {
  name                        = var.sql_db_name
  server_id                   = azurerm_mssql_server.server.id
  sku_name                    = var.sku_name
  min_capacity                = 0.5
  auto_pause_delay_in_minutes = 60
  zone_redundant              = false

  tags = var.tags

  # # prevent the possibility of accidental data loss
  # lifecycle {
  #   prevent_destroy = true
  # }
}
