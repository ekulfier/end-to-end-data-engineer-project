module "azure-sql-database-server" {
  source                     = "../modules/azure-sql-database-server"
  resource_group_location    = var.resource_group_location
  resource_group_name_prefix = var.resource_group_name_prefix
  mssql_server_name          = var.mssql_server_name
  sql_db_name                = var.sql_db_name
  admin_username             = var.admin_username
  tags                       = var.tags
  sku_name                   = var.sku_name
}
