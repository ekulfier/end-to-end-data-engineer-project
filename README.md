# Data Engineering End-to-End Project 🚀

## Overview
This project provides a complete data pipeline using Azure services, enabling seamless data ingestion, processing, and querying. The infrastructure is provisioned using **Terraform**, ensuring easy deployment and configuration.

✨ *This setup ensures a scalable, manageable, and efficient data pipeline on Azure!* ✨

# Data Model Pipeline - Key Takeaways

## 📌 Overview
This Databricks workflow and Azure Data Factory is designed to process car sales data using a Medallion Architecture Framework, including **Silver** (processed data) and **Gold** (analytical data model) layers.

## 🔹 1. Data Pipeline Structure
- **Silver Layer (Processed Data)**
  - Reads raw data from **Azure Data Lake Storage (ADLS) - Bronze Layer**.
  - Performs **data transformations**, including:
    - Extracting `model_category` from `Model_ID`
    - Calculating `RevPerUnit` (Revenue per Unit Sold)
  - Writes transformed data back to **Silver Layer** in ADLS.

- **Gold Layer (Data Model)**
  - Creates **Dimension Tables**:  
    - `dim_branch`, `dim_dealer`, `dim_model`, `dim_date`
  - Builds **Fact Table (`fact_sales`)** by joining with dimensions.
  - Implements **Delta Table (SCD Type 1 - UPSERT)** for incremental updates.

## 🔹 2. Incremental Processing Strategy
- Uses **Watermarking Strategy** to handle incremental data loads.
- **dbutils.widgets** are used to define the **incremental_flag**.
- Fact Table (`fact_sales`) uses **Merge (UPSERT) Strategy** with Delta Tables.

## 🔹 3. Databricks Workflow & Job Orchestration
- The workflow consists of:
  1. **Silver Data Processing**
  2. **Creating Dimension Tables (`dim_branch`, `dim_date`, `dim_dealer`, `dim_model`)**
  3. **Building the Fact Table (`fact_sales`)**
- Runs on **Databricks Cluster** and uses **Databricks SQL** for querying.

## 🔹 4. Best Practices Implemented
✅ **Delta Tables** for efficient storage and incremental processing.  
✅ **Parquet Format** for optimized read/write performance.  
✅ **Data Validation** via schema enforcement and joins.  
✅ **Databricks SQL Queries** for efficient querying and reporting.  

## 📌 Future Improvements 
🚀 Implement **CI/CD Pipelines** using **GitHub Actions + Databricks Repos**.  
🚀 Enable **Monitoring & Alerting** with **Databricks Job Alerts / Azure Monitor**.  

---

This workflow ensures a **scalable, efficient, and maintainable** data pipeline for analytics. 🚀  


## Infrastructure Setup 🏗️
All resources in this project are deployed on **Azure** and managed with [Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest).

### Deployment Steps
1. **Deploy Azure Database Server** 📂  
   Terraform Path: `/infra/00-infra-azure-mysql`
   - Creates an **Azure MySQL Server** as the main data source.

2. **Deploy Azure Databricks Workspace** 💡  
   Terraform Path: `/infra/01-infra-adb-workspace`
   - Sets up an **Azure Databricks Workspace** for data transformation and analytics.

3. **Setup Unity Catalog for Governance** 🔍  
   Terraform Path: `/infra/02-infra-adb-unity-catalog`
   - Implements **Unity Catalog** for data governance and access control.

4. **Deploy Azure Data Factory Workspace** 🔄  
   Terraform Path: `/infra/03-infra-adf-workspace`
   - Creates an **Azure Data Factory (ADF) instance** for data ingestion and orchestration.

### All AZURE Service we will use
- Azure MySQL Server 
- Azure MySQL Database
- Azure Databricks Workspace
- Storage Account (Datalake, Unity Catalog, Audit For MySQL)
- Azure Data Factory
- Azure Virtual Machine (Spark Cluster)

---

# Solution Incremental Pipeline End to End
## Incremental Pipeline End to End

### 1. change the data set file  [Go to Source Data Pipeline Flow](#source-data-pipeline-flow)
- ![ingest](/images/end-to-end/ingest.png)
- ![ingest_output](/images/end-to-end/ingest_output.png)
### 2. Run Incremental Pipeline  [Go to Incremental Data Pipeline Flow](#incremental-data-pipeline-flow)
- ![db_increm](/images/end-to-end/db_increm.png)
- ![increm](/images/end-to-end/increm.png)
### 3. Run Databricks Workflow [Go to Databrick Workflow](#data-model-workflow)
- ![db_increm](/images/end-to-end/adb-workflow.png)
### 4. Verify the ingested data in the fact table
- ![](/images/end-to-end/end.png)

---

## Source Data Pipeline Flow

1. **Source Data Ingestion** 📥  
   - Dataset is ingested from git into the **Azure MySQL Database**.
   ![source_file](/images/adf/source_prep/source_file.png)

2. **Data Sink** 🏦  
   - The ingested data is stored in an **Azure MySQL Database**.
   ![source_file](/images/adf/source_prep/sink_table.png)

3. **Mapping** 🔄  
   - Data is processed to mapping between  **Dataset**. and  **Azure MySQL Database**. 

4. **Run Jobs** ⚙️  
   - Triggers **ADF Pipeline** to process data.

5. **Query Processed Data** 🔍  
   - The processed data is ready to use.


**Job Complete**
![runjob_success](/images/adf/source_prep/runjob_success.png)

[For more Information about Source Pipeline ](/infra/03-infra-adf-workspace/README.md)

## Incremental Data Pipeline Flow 

Overview

This pipeline is designed to perform incremental data loading by leveraging lookup activities to determine the last and current load timestamps. The data is then copied and processed before updating the watermark.

![increm_pipeline](/images/adf/increm_data_pipeline/increm_pipeline.png)

1. **Lookup last_load 🔍**
   - Retrieves the last successful load timestamp from a **water_table**.
   ![last_load](/images/adf/increm_data_pipeline/last_load.png)

2. **Lookup current_load 🔍** 
   - Fetches the current timestamp for the new data to be loaded.
   ![current_load](/images/adf/increm_data_pipeline/current_load.png)

3. **Copy_Increm_Data 📥**
   - Copies the incremental data based on the difference between last_load and current_load timestamps. 
   ![source](/images/adf/increm_data_pipeline/source.png)
   ```
   -- Query
   SELECT * FROM source_cars_data WHERE Date_ID > '@{activity('last_load').output.value[0].last_load}' AND Date_ID <= '@{activity('current_load').output.value[0].max_date}'
   ```
    - data copy to datalake bronze layer. 
	![sink](/images/adf/increm_data_pipeline/sink.png)

4. **WatermarkUpdate 📝**
   - Updates the stored **watermark** to reflect the latest successfully processed data via **Procedure**.
   ![watermark_pipeline](/images/adf/increm_data_pipeline/watermark_pipeline.png)


5. **Query Processed Data** 🔍  
   - The processed data is ready to use.

**Job Complete** 

![source-sink](/images/adf/increm_data_pipeline/source-sink.png)

**Watermark Table Updated**

![watermark_updated](/images/adf/increm_data_pipeline/watermark_updated.png)

## Databrick with Unity Catalog 🔥📂🔒

Overview

Databricks with Unity Catalog is a unified data governance solution designed to manage, secure, and organize data across multiple cloud environments. It extends Databricks capabilities by adding a centralized metadata layer, fine-grained access controls, and robust security features to ensure data compliance and governance at scale.

![unity-catalog](/images/adb/Gorvernance/unity-catalog.png)
![adb-workspace](/images/adb/Gorvernance/adb-workspace.png)
[For more Information about Databrick with Unity Catalog for Data Governance ](/infra/02-infra-adb-unity-catalog/README.md)

# Cars Project with Medallion Architecture Framework

## Silver Layer Notebook 📂 - Databricks

## Overview
This Databricks notebook processes raw data from the Bronze layer, applies transformations, and writes the cleaned data to the Silver layer for further analysis.

## Silver Workflow

### 1. Data Reading 📥
- Reads raw data from the **Bronze layer** stored in **Azure Data Lake Storage (ADLS)**.
- Uses **Parquet** format for optimized storage and performance.

```python
 df = spark.read.format('parquet') \
        .option('inferSchema', True) \
        .load('abfss://dev-catalog@adbcdadventustorageaccuc.dfs.core.windows.net/bronze/rawdata')
```

### 2. Data Transformation 🔄
- Extracts `model_category` from `Model_ID`.
- Ensures `Units_Sold` is stored as a **StringType**.
- Calculates `RevPerUnit` by dividing `Revenue` by `Units_Sold`.

```python
from pyspark.sql.functions import col, split, sum
from pyspark.sql.types import StringType

df = df.withColumn('model_category', split(col('Model_ID'), '-')[0])
df = df.withColumn('RevPerUnit', col('Revenue')/col('Units_Sold'))
```

### 3. Ad-Hoc Analysis 📊
- Displays data interactively.
- Aggregates total units sold by **Year** and **BranchName**.

```python
display(df.groupBy('Year', 'BranchName').agg(sum('Units_Sold').alias('Total_Units')).sort('Year', 'Total_Units', ascending=[1,0]))
```

### 4. Data Writing 💾
- Writes the transformed data to the **Silver layer** in **Parquet format**.
- Uses **overwrite mode** to refresh data.

```python
df.write.format('parquet') \
    .mode('overwrite') \
    .option('path', 'abfss://dev-catalog@adbcdadventustorageaccuc.dfs.core.windows.net/silver/') \
    .save()
```

### 5. Querying Silver Data 🔍
- Reads the processed Silver data using **SQL**.

```sql
SELECT * FROM parquet.`abfss://dev-catalog@adbcdadventustorageaccuc.dfs.core.windows.net/silver`
```

## Gold Dimension Notebook 🗂 - Databricks

## Overview
This Databricks notebook is designed for processing and managing **dimension tables** in the **Gold Layer** of the data lake. It supports both **initial loads** and **incremental updates** using **Slowly Changing Dimension (SCD) Type 1 (Upsert)**.

![DimGoldSilver](/images/adb/modeling/DimGoldSilver.drawio.png)

## Supported Dimension Notebooks
This notebook structure applies to the following **Gold Dimension** tables:
- `gold_dim_branch`
- `gold_dim_date`
- `gold_dim_dealer`
- `gold_dim_model`

## Gold Dim Workflow
### 1. Create Incremental Flag Parameter ⚙️
- Uses `dbutils.widgets` to determine whether the run is **initial** (`0`) or **incremental** (`1`).

```python
dbutils.widgets.text('incremental_flag', '0')
incremental_flag = dbutils.widgets.get('incremental_flag')
```

### 2. Data Extraction 📥
- Reads the source data from the **Silver Layer**.
- Extracts relevant columns for the dimension table.

```python
df_src = spark.sql('''
    select distinct(Branch_ID) as Branch_ID, BranchName
    from parquet.`abfss://dev-catalog@adbcdadventustorageaccuc.dfs.core.windows.net/silver`
    ''')
```

### 3. Check Existing Dimension Table 🛠️
- If the dimension table exists, retrieve the current records.
- Otherwise, create an empty schema.

```python
if spark.catalog.tableExists('cars_catalog.gold.dim_branch'):
    df_sink = spark.sql('''
    SELECT dim_branch_key, Branch_ID, BranchName
    FROM cars_catalog.gold.dim_branch
    ''')
else:
    df_sink = spark.sql('''
    SELECT 1 as dim_branch_key, Branch_ID, BranchName
    FROM parquet.`abfss://dev-catalog@adbcdadventustorageaccuc.dfs.core.windows.net/silver`
    WHERE 1=0
    ''')
```

### 4. Filter New and Existing Records 🔍
- **Existing Records (`df_filter_old`)**: Already present in the dimension table.
- **New Records (`df_filter_new`)**: Need to be inserted with a surrogate key.

```python
df_filter_old = df_filter.filter(col('dim_branch_key').isNotNull())
df_filter_new = df_filter.filter(col('dim_branch_key').isNull()).select(df_src['Branch_ID'], df_src['BranchName'])
```

### 5. Create Surrogate Key 🔢
- Fetch the max surrogate key from the existing table.
- Assign a new key for incremental records.

```python
if incremental_flag == '0':
    max_value = 1
else:
    max_value_df = spark.sql("select max(dim_branch_key) from cars_catalog.gold.dim_branch")
    max_value = max_value_df.collect()[0][0] + 1

df_filter_new = df_filter_new.withColumn('dim_branch_key', max_value + monotonically_increasing_id())
```

### 6. Merge New and Old Records 🏗️
- Combines existing and new records into a final DataFrame.

```python
df_final = df_filter_new.union(df_filter_old)
```

### 7. Upsert into Gold Layer (SCD Type 1) 🚀
- Uses **Delta Lake Merge** to update existing records and insert new ones.

```python
from delta.tables import DeltaTable

if spark.catalog.tableExists('cars_catalog.gold.dim_branch'):
    delta_tbl = DeltaTable.forPath(spark, "abfss://gold@carcddatalake.dfs.core.windows.net/dim_branch")
    delta_tbl.alias("trg").merge(df_final.alias("src"), "trg.dim_branch_key = src.dim_branch_key") \
            .whenMatchedUpdateAll() \
            .whenNotMatchedInsertAll() \
            .execute()
else:
    df_final.write.format("delta") \
        .mode('overwrite') \
        .option("path", "abfss://gold@carcddatalake.dfs.core.windows.net/dim_branch") \
        .saveAsTable("cars_catalog.gold.dim_branch")
```

### 8. Validate Data ✅
- Query the updated dimension table.

```sql
SELECT * FROM cars_catalog.gold.dim_branch;
```

## Notes 📌
- The logic applies to all dimension tables (`dim_branch`, `dim_date`, `dim_dealer`, `dim_model`).
- Ensure that `incremental_flag` is set correctly before running.
- The **SCD Type 1 Upsert** ensures that the latest data is always reflected in the Gold layer.

**[It is located in the repository /codepipelin/adb-workspace for another DIM Nootbook. ](/code-pipeline/adb-workspace/)**

---
# Gold Fact Sales Notebook

## Overview
This notebook is responsible for creating and updating the **Fact Sales Table** in the **Gold Layer** of the data lake. It integrates **Silver Layer data** with all necessary **Dimension Tables (DIMS)** to build a structured fact table.

![fact-sales](/images/adb/modeling/fact-sales.png)

## Steps in the Notebook

### 1. Reading Silver Data
- The notebook starts by reading raw transactional data from the **Silver Layer** stored in **Azure Data Lake Storage (ADLS)**.

### 2. Reading Dimension Tables
- All required dimension tables are fetched from the **Gold Layer**:
  - `dim_dealer`
  - `dim_branch`
  - `dim_model`
  - `dim_date`

### 3. Joining Dimensions with Silver Data
- The fact table is built by joining the Silver Data with the respective **Dimension Tables** to bring in their **keys**.

### 4. Writing to Fact Sales Table
- The final fact table is written into the **Gold Layer** as a **Delta Table** with support for **incremental updates** using the following logic:
  - **If the table exists**, an **upsert (MERGE)** is performed based on matching keys.
  - **If the table does not exist**, the data is written as a new table.

### 5. Querying Fact Sales Data
- A final query is run to verify that the `factsales` table has been correctly updated.

## Storage & Path Details
- **Source Data (Silver Layer):** `abfss://dev-catalog@adbcdadventustorageaccuc.dfs.core.windows.net/silver`
- **Target Data (Gold Layer - Fact Sales Table):** `abfss://dev-catalog@adbcdadventustorageaccuc.dfs.core.windows.net/gold/factsales`

## Technologies Used
- **Apache Spark (PySpark)**
- **Azure Data Lake Storage (ADLS)**
- **Delta Lake**
- **Databricks SQL**

## Notes
- This notebook ensures **Slowly Changing Dimension (SCD) Type 1** processing for updates.
- Data integrity is maintained using **JOIN operations** and **Delta Lake Merge**.
- The notebook is designed to run in both **initial load** and **incremental update** modes.

---

**Next Steps:**
- Ensure all dimension tables are properly updated before running this notebook.
- Validate `factsales` table data in **Databricks SQL** after execution.

**[For gold fact located in /codepipelin/adb-workspace/gold_fact_sales.py ](/code-pipeline/adb-workspace/gold_fact_sales.py)**

# Data-Model Workflow 

## Overview
This workflow is designed to process and transform car sales data through different stages in a **Databricks** environment. The workflow consists of multiple **Databricks notebooks**, each responsible for handling specific tasks within the data pipeline.

![](/images/adb/modeling/adb-workflow.png)

## Workflow Structure 🚀
The workflow follows a structured process to transform **Silver Data** into a structured **Fact Table** by leveraging dimension tables.

### 1. **Silver_Data**
   - Reads raw sales data from the **Silver Layer**.
   - Performs necessary **data transformations** and **data cleaning**.
   - Serves as a source for **dimension** and **fact tables**.

### 2. **Dimension Tables** (Gold Layer)
Each dimension table extracts and structures specific attributes from the **Silver Layer** to facilitate data normalization and improve query performance.

- **Dim_Branch**
  - Extracts and stores unique **Branch** details.
- **Dim_Date**
  - Creates a structured **Date** dimension for time-based analysis.
- **Dim_Dealer**
  - Stores **Dealer**-related information.
- **Dim_Model**
  - Extracts and organizes **Model** details.

### 3. **Fact_Sales**
   - Combines **Silver Data** with all **Dimension Tables**.
   - Stores sales transactions along with foreign keys from dimensions.
   - Ensures **historical tracking** and enables analytical queries.

## Workflow Execution
1. **Silver_Data Notebook** runs first to prepare the source data.
2. Each **Dimension Notebook** (Dim_Branch, Dim_Date, Dim_Dealer, Dim_Model) runs in parallel to extract relevant information.
3. Once all **dimensions** are ready, the **Fact_Sales Notebook** runs to construct the final fact table.

## Technologies Used
- **Databricks Notebooks**
- **Apache Spark** (PySpark SQL, DataFrames)
- **Delta Lake** (for incremental and historical tracking)
- **Azure Data Lake Storage (ADLS)** (for storing Silver and Gold data)

## Benefits of this Workflow
✅ **Modular Design** - Each step is handled in separate notebooks for better manageability.
✅ **Parallel Processing** - Dimensions are processed in parallel for faster execution.
✅ **Incremental Updates** - Uses Delta Lake for efficient data updates and historical tracking.
✅ **Optimized Query Performance** - Fact table is structured for efficient reporting and analysis.

## Next Steps
- Implement **orchestration** using **Databricks Workflows** or **Azure Data Factory (ADF)**.
- Enhance **data validation** before ingestion.
- Optimize storage and indexing for **better performance**.

---
🎯 This workflow ensures a **scalable, high-performance data model** for analyzing car sales effectively.




