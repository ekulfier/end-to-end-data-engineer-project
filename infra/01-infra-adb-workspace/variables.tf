variable "workspace_name" {
  description = "Name of Azure Databricks Workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of Resource Group"
  type        = string
}

variable "location" {
  description = "Region of Azure"
  type        = string
}

variable "tags" {
  description 	= "The tags associated with your resource"
  type 			= map(string)
}

variable "sku" {
  description = "Type of Azure Databricks"
  type        = string
}
