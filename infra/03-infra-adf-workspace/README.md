# Terraform Variables for Azure Data Factory Deployment

This Terraform module defines variables for deploying an Azure Data Factory (ADF) along with its required resources.

## Variables

### 1. `resource_group_name`
- **Type**: `string`
- **Description**: The name of the Azure Resource Group where the Data Factory will be deployed.

### 2. `location`
- **Type**: `string`
- **Description**: The Azure region where the resources will be deployed.

### 3. `tags`
- **Type**: `map(string)`
- **Description**: Tags associated with the resources for better organization and management.

### 4. `storage_account_name`
- **Type**: `string`
- **Description**: The name of the Azure Storage Account used for data storage.

### 5. `linked_resource_group_name`
- **Type**: `string`
- **Description**: The name of the linked resource group.

### 6. `adf_name`
- **Type**: `string`
- **Description**: The name of the Azure Data Factory instance.

### 7. `subscription_id`
- **Type**: `string`
- **Description**: The Azure subscription ID where the resources will be deployed.

## Usage
To use these variables in your Terraform configuration, define them in your `terraform.tfvars` file or provide values when running Terraform commands.

### Example:
```hcl
variable "resource_group_name" {
  default = "my-resource-group"
}

variable "location" {
  default = "eastus"
}

variable "storage_account_name" {
  default = "mystorageaccount"
}

variable "adf_name" {
  default = "my-data-factory"
}
```

## Applying the Configuration
Run the following Terraform commands to deploy the Azure Data Factory:

```sh
terraform init
terraform plan
terraform apply
```

## Notes
- Ensure that `adf_name` is unique within your Azure subscription.
- The `subscription_id` should match the correct Azure account where the resources will be created.
- Use Azure CLI or other secret management tools to securely pass sensitive values.

## ADF Link Service
![ls](/images/adf/init/ls.png)

## ADF Dataset
![ds_bronze](/images/adf/init/ds_bronze.png)
![ds_git](/images/adf/init/ds_git.png)
![ds_sqlDB](/images/adf/init/ds_sqlDB.png)

## ADF Pipeline
![source_prep](/images/adf/init/source_prep.png)
![sink_prep](/images/adf/init/sink_prep.png)