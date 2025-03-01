# Azure SQL Database - Watermark Table Concept

## Overview
This project demonstrates the implementation of a **Watermark Table** in an Azure SQL Database. The watermark table is used to track the last processed data point in an incremental data load scenario.

## Components

### 1. Watermark Table (`water_table`)
- Stores the latest processed timestamp or ID.
- Ensures only new data is processed in subsequent runs.

### 2. Stored Procedure (`UpdateWatermarkTable`)
- Updates the `water_table` with the most recent processed ID.
- Uses transactions to maintain data consistency.

### 3. Incremental Data Extraction
- Queries new data from `source_cars_data` based on the last recorded watermark.
- Ensures efficient data processing without duplication.

## SQL Implementation

### Create Watermark Table
```sql
CREATE TABLE water_table (
    last_load VARCHAR(2000)
);
```

### Insert Initial Watermark
```sql
INSERT INTO water_table VALUES ('DT00000');
```

### Query to Extract New Data
```sql
SELECT COUNT(*)
FROM dbo.source_cars_data
WHERE DATE_ID > (SELECT MAX(last_load) FROM dbo.water_table);
```

![init_water_table](/images/adf/increm_data_pipeline/init_water_table.png)

### Stored Procedure for Updating Watermark
```sql
CREATE PROCEDURE UpdateWatermarkTable
    @lastload VARCHAR(200)
AS
BEGIN
    BEGIN TRANSACTION;
    
    UPDATE water_table
    SET last_load = @lastload;

    COMMIT TRANSACTION;
END;
```

## Execution Flow

1. **Initialize the watermark table** with a starting value.
2. **Extract new data** from `source_cars_data` based on the last processed `DATE_ID`.
3. **Process and load the new data** into the target system.
4. **Update the watermark table** using `UpdateWatermarkTable` stored procedure.

## Benefits of Using a Watermark Table

- **Ensures incremental loading:** Avoids processing duplicate data.
- **Enhances efficiency:** Reduces unnecessary database reads.
- **Maintains consistency:** Uses transactions to prevent data corruption.

