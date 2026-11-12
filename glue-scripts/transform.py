
import sys

from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from pyspark.sql.functions import (
    col,
    trim,
    upper,
    when,
    to_timestamp
)

# 1. Get input and output paths
args = getResolvedOptions(
    sys.argv,
    ["S3_INPUT_PATH", "S3_OUTPUT_PATH"]
)

# 2. Initialize Spark and Glue
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# 3. Read Online Retail CSV
df = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .option("encoding", "UTF-8")
    .csv(args["S3_INPUT_PATH"])
)

print("Original record count:", df.count())

# 4. Remove duplicate records
cleaned_df = df.dropDuplicates()

# 5. Standardize text columns
cleaned_df = (
    cleaned_df
    .withColumn("InvoiceNo", trim(col("InvoiceNo").cast("string")))
    .withColumn("StockCode", trim(col("StockCode")))
    .withColumn("Description", trim(col("Description")))
    .withColumn("Description", when(
        col("Description").isNull() | (col("Description") == ""),
        "UNKNOWN"
    ).otherwise(col("Description")))
    .withColumn("Country", trim(col("Country")))
    .withColumn("Country", upper(col("Country")))
)

# 6. Convert data types
cleaned_df = (
    cleaned_df
    .withColumn("Quantity", col("Quantity").cast("int"))
    .withColumn("UnitPrice", col("UnitPrice").cast("double"))
    .withColumn("CustomerID", col("CustomerID").cast("long"))
    .withColumn("InvoiceDate", to_timestamp(col("InvoiceDate")))
)

# 7. Remove invalid mandatory records
cleaned_df = cleaned_df.filter(
    col("InvoiceNo").isNotNull() &
    col("StockCode").isNotNull() &
    col("InvoiceDate").isNotNull() &
    col("Quantity").isNotNull() &
    col("UnitPrice").isNotNull() &
    (col("Quantity") != 0) &
    (col("UnitPrice") > 0)
)

# 8. Identify sales, returns and cancellations
cleaned_df = cleaned_df.withColumn(
    "TransactionType",
    when(col("InvoiceNo").startswith("C"), "CANCELLATION")
    .when(col("Quantity") < 0, "RETURN")
    .otherwise("SALE")
)

# 9. Calculate revenue
cleaned_df = cleaned_df.withColumn(
    "Revenue",
    col("Quantity") * col("UnitPrice")
)

# 10. Write cleaned data as Parquet
cleaned_df.write \
    .mode("overwrite") \
    .parquet(args["S3_OUTPUT_PATH"])

# 11. Print final statistics
print("Glue ETL job completed successfully")
print("Cleaned record count:", cleaned_df.count())

print("Transaction type summary:")
cleaned_df.groupBy("TransactionType").count().show()

print("Country-wise transaction summary:")
cleaned_df.groupBy("Country").count().show(10)
