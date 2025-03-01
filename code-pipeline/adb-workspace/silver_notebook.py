# Databricks notebook source
# MAGIC %md
# MAGIC # DATA READING

# COMMAND ----------

df = spark.read.format('parquet') \
        .option('inferSchema', True) \
        .load('abfss://bronze@carcddatalake.dfs.core.windows.net/rawdata')

# COMMAND ----------

df.display()

# COMMAND ----------

# MAGIC %md
# MAGIC # DATA TRANSFORMATION

# COMMAND ----------

from pyspark.sql.functions import col, split, sum
from pyspark.sql.types import StringType

# COMMAND ----------

df = df.withColumn('model_category', split(col('Model_ID'), '-')[0])

# COMMAND ----------

df.display()

# COMMAND ----------

df.withColumn('Units_Sold', col('Units_Sold').cast(StringType())).printSchema()

# COMMAND ----------

df = df.withColumn('RevPerUnit', col('Revenue')/col('Units_Sold'))
df.display()

# COMMAND ----------

# MAGIC %md
# MAGIC # AD-HOC

# COMMAND ----------

df.display()

# COMMAND ----------

display(df.groupBy('Year', 'BranchName').agg(sum('Units_Sold').alias('Total_Units')).sort('Year', 'Total_Units', ascending=[1,0]))

# COMMAND ----------

# MAGIC %md
# MAGIC # DATA WRITING

# COMMAND ----------

df.write.format('parquet') \
    .mode('overwrite') \
    .option('path', 'abfss://silver@carcddatalake.dfs.core.windows.net/carsales/') \
    .save()

# COMMAND ----------

# MAGIC %md
# MAGIC # Querying Silver Data

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM parquet.`abfss://silver@carcddatalake.dfs.core.windows.net/carsales`

# COMMAND ----------

