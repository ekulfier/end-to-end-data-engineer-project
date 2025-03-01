variable "resource_group_name" {
  description 	= "The name of the resource group"
  type 			= string
}

variable "storage_account_name" {
  description 	= "The name of the storage account"
  type 			= string
}

variable "location" {
  description 	= "The location/region of the resource"
  type 			= string
}

variable "adf_name" {
	description = "The data factory name"
	type = string
  
}

variable "linked_resource_group_name" {
  description 	= "The name of the linked resource group"
  type 			= string
}