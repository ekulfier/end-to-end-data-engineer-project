# Terraform Variables for Azure Databricks Deployment

This Terraform module defines variables for deploying an Azure Databricks workspace along with its required resources.

## Variables

### 1. `workspace_name`
- **Type**: `string`
- **Description**: Name of the Azure Databricks Workspace.

### 2. `resource_group_name`
- **Type**: `string`
- **Description**: Name of the Azure Resource Group where the Databricks workspace will be deployed.

### 3. `location`
- **Type**: `string`
- **Description**: Azure region where the resources will be deployed.

### 4. `tags`
- **Type**: `map(string)`
- **Description**: Tags associated with the resources for better organization and management.

### 5. `sku`
- **Type**: `string`
- **Description**: Type of Azure Databricks SKU (e.g., Standard, Premium, or Enterprise).

## Usage
To use these variables in your Terraform configuration, define them in your `terraform.tfvars` file or provide values when running Terraform commands.

### Example:
```hcl
variable "workspace_name" {
  default = "my-databricks-workspace"
}

variable "resource_group_name" {
  default = "my-resource-group"
}

variable "location" {
  default = "eastus"
}

variable "sku" {
  default = "standard"
}
```

## Applying the Configuration
Run the following Terraform commands to deploy the Databricks workspace:

```sh
terraform init
terraform plan
terraform apply
```

## Notes
- Ensure that the `workspace_name` is unique within your Azure subscription.
- Choose the appropriate `sku` based on your workload requirements.
- Use Azure CLI or other secret management tools to securely pass sensitive values.

