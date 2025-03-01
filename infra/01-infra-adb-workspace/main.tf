module "databricks" {
  source              = "../modules/adb-workspace"
  workspace_name      = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  tags                = var.tags
}

output "databricks_workspace_url" {
  value = module.databricks.workspace_url
}
