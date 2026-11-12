
import pandas as pd

# Read original Excel dataset
df = pd.read_excel("data/Online Retail.xlsx")

# Select first 20,000 records
sample_df = df.head(20000).copy()

# Save as CSV
sample_df.to_csv(
    "data/online_retail_sample.csv",
    index=False,
    encoding="utf-8"
)

# Display sample information
print("Sample dataset created successfully!")
print("Total records:", len(sample_df))
print("Total columns:", len(sample_df.columns))
print("Output file: data/online_retail_sample.csv")
