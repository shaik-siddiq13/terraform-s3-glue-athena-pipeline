
import pandas as pd

# Read Excel dataset
file_path = "data/Online Retail.xlsx"

df = pd.read_excel(file_path)

# Display dataset information
print("\n--- DATASET SHAPE ---")
print("Rows and Columns:", df.shape)

print("\n--- COLUMN NAMES ---")
print(df.columns.tolist())

print("\n--- FIRST 5 RECORDS ---")
print(df.head())

print("\n--- DATA TYPES ---")
print(df.dtypes)

print("\n--- MISSING VALUES ---")
print(df.isnull().sum())

print("\n--- DUPLICATE RECORDS ---")
print(df.duplicated().sum())
