output "databricks_workspace_url" {
  description = "URL of Azure Databricks Workspace"
  value       = azurerm_databricks_workspace.this.workspace_url
}

output "databricks_workspace_id" {
  description = "ID of Azure Databricks Workspace"
  value       = azurerm_databricks_workspace.this.id
}
