resource "azurerm_data_factory" "adf" {
  name = var.adf_name
  resource_group_name = var.resource_group_name
  location = var.location

  identity {
	type = "SystemAssigned"
  }
}

data "azurerm_storage_account" "bronze_folder_storage" {
  name = var.storage_account_name
  resource_group_name = var.linked_resource_group_name
}
########### linked_service ###############

# Datalake

resource "azurerm_data_factory_linked_service_azure_blob_storage" "source_datalake" {
  name = "${var.storage_account_name}-storage"
  data_factory_id = azurerm_data_factory.adf.id
  connection_string = data.azurerm_storage_account.bronze_folder_storage.primary_connection_string
}

# Github

resource "azurerm_data_factory_linked_custom_service" "ls_github" {
  name                 = "ls_github"
  data_factory_id      = azurerm_data_factory.adf.id
  type                 = "HttpServer"
  description          = "linked github"
  type_properties_json = <<JSON
{
  "authenticationType":"Anonymous",
  "url":"https://raw.githubusercontent.com/"
}
JSON
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "ls_sqlDB" {
  name                = "ls_sqlDB"
  data_factory_id     = azurerm_data_factory.adf.id
  connection_string = "data source=cdcarssalesserver.database.windows.net;initial catalog=carsales;user id=admincd;Password=YourPassword;integrated security=False;encrypt=True;connection timeout=30"
}

########### linked_service ###############

########### dataset ###############

# source and sink dataset to blob storage
resource "azurerm_data_factory_dataset_parquet" "ds_bronze" {
  name = "ds_bronze"
  data_factory_id = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.source_datalake.name

  azure_blob_storage_location {
    container = "dev-catalog"
    path = "bronze/rawdata"
    
  }
  compression_codec = "snappy"

}

resource "azurerm_data_factory_dataset_delimited_text" "ds_git" {
  name                = "ds_git"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_custom_service.ls_github.name

  parameters = {
    load_flag = ""
  }

  http_server_location {
    relative_url = "ekulfier/dataset/refs/heads/main/cars-project/@{dataset().load_flag}"
    path         = "x"
    filename     = "x"
    dynamic_filename_enabled = true
    dynamic_path_enabled     = true
  }

  column_delimiter    = ","
  row_delimiter = "\n"
  encoding            = "UTF-8"
  quote_character  = "\""
  escape_character = "\\"
  first_row_as_header = true
  null_value          = "NULL"
}

resource "azurerm_data_factory_custom_dataset" "ds_sqlDB" {
  name            = "ds_sqlDB"
  data_factory_id = azurerm_data_factory.adf.id
  type            = "AzureSqlTable"

  linked_service {
    name = azurerm_data_factory_linked_service_azure_sql_database.ls_sqlDB.name
  }

  parameters = {
    table_name = ""
  } 

  type_properties_json = <<JSON
{
  "tableName": "@dataset().table_name"
}
JSON
  annotations = []
  schema_json = jsonencode([])
}
########### dataset ###############

########### Source Pipeline ###############
resource "azurerm_data_factory_pipeline" "source_prep" {

  name            = "source_prep"
  data_factory_id = azurerm_data_factory.adf.id

  activities_json = <<JSON
[
  {
    "name": "source_prep",
    "type": "Copy",
    "typeProperties": {
      "source": {
        "type": "DelimitedTextSource",
        "storeSettings": {
          "type": "HttpReadSettings",
          "requestMethod": "GET"
        },
        "formatSettings": {
          "type": "DelimitedTextReadSettings"
        }
      },
      "sink": {
        "type": "AzureMySqlSink"
      },
      "enableStaging": false
    },
    "policy": {
      "timeout": "7.00:00:00",
      "retry": 0,
      "retryIntervalInSeconds": 30,
      "secureInput": false,
      "secureOutput": false
    },
    "inputs": [
      {
        "referenceName": "ds_git",
        "type": "DatasetReference"
      }
    ],
    "outputs": [
      {
        "referenceName": "ds_sqlDB",
        "type": "DatasetReference"
      }
    ]
  }
]
JSON

  depends_on = [
    azurerm_data_factory_dataset_parquet.ds_bronze,
    azurerm_data_factory_dataset_delimited_text.ds_git,
    azurerm_data_factory_custom_dataset.ds_sqlDB
  ]
}

########### Source Pipeline ###############