variable "resource_group_location" {
  type        = string
  description = "Location for all resources."
  default     = "southeastasia"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "rg"
}

variable "mssql_server_name" {
  type        = string
  description = "Prefix of the mysql server name that's combined with a random ID so name is unique in your Azure subscription."
}


variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "SampleDB"
}

variable "sku_name" {
  description = "Type of Azure SQL Database"
  type        = string
}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}

variable "tags" {
  description 	= "The tags associated with your resource"
  type 			= map(string)
}