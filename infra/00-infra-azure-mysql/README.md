# Terraform Variables for Azure SQL Database Deployment

This Terraform module provides a set of variables for deploying an Azure SQL Database along with its required resources.

![carsales](/images/database/carsales.png)

## Variables

### 1. `resource_group_location`
- **Type**: `string`
- **Description**: Location for all resources.
- **Default**: `southeastasia`

### 2. `resource_group_name_prefix`
- **Type**: `string`
- **Description**: Prefix of the resource group name that's combined with a random ID to ensure uniqueness within your Azure subscription.
- **Default**: `rg`

### 3. `mssql_server_name`
- **Type**: `string`
- **Description**: Prefix of the MySQL server name combined with a random ID to ensure uniqueness within your Azure subscription.

### 4. `sql_db_name`
- **Type**: `string`
- **Description**: The name of the SQL Database.
- **Default**: `SampleDB`

### 5. `sku_name`
- **Type**: `string`
- **Description**: Type of Azure SQL Database SKU.

### 6. `admin_username`
- **Type**: `string`
- **Description**: The administrator username for the SQL logical server.
- **Default**: `azureadmin`

### 7. `admin_password`
- **Type**: `string`
- **Description**: The administrator password for the SQL logical server.
- **Sensitive**: `true`
- **Default**: `null`

### 8. `tags`
- **Type**: `map(string)`
- **Description**: Tags associated with your resource.

## Usage
To use these variables in your Terraform configuration, declare them in your `terraform.tfvars` file or provide values when running Terraform commands.

### Example:
```hcl
variable "resource_group_location" {
  default = "eastus"
}

variable "mssql_server_name" {
  default = "my-sql-server"
}

variable "sql_db_name" {
  default = "MyDatabase"
}

variable "sku_name" {
  default = "Basic"
}
```

## Applying the Configuration
Run the following Terraform commands:

```sh
terraform init
terraform plan
terraform apply
```

## Notes
- Ensure that the `admin_password` is securely managed and not hardcoded in your Terraform files.
- Use Azure CLI or other secret management solutions to securely pass sensitive values.

