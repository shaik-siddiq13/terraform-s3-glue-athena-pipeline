\# AWS Online Retail Data Engineering Pipeline



An end-to-end AWS Data Engineering project using Terraform and AWS services.



\## Architecture



S3 Raw Data → S3 Event Notification → Lambda → AWS Glue (PySpark) → S3 Parquet → Glue Crawler → Athena



\## Technologies



\- Terraform

\- Amazon S3

\- AWS Lambda (Python)

\- AWS Glue 4.0

\- PySpark

\- Glue Data Catalog

\- Amazon Athena

\- SQL



\## Data Transformations



\- Duplicate removal

\- Missing value handling

\- Data type conversion

\- Text standardization

\- Invalid record filtering

\- Sales and cancellation identification

\- Revenue calculation

\- Parquet output generation



\## Sample Results



| Metric | Result |

|---|---:|

| Input records | 20,000 |

| Cleaned records | 19,549 |

| Sales revenue | 398,780.14 |

| Cancellation revenue | -60,367.30 |

| Net revenue | 338,412.84 |



\*Results are from the 20,000-row development sample.\*



\## Deployment



1\. Configure AWS CLI.

2\. Update bucket names and account configuration.

3\. Prepare the dataset using `python prepare\_sample.py`.

4\. Create Lambda ZIP using `Compress-Archive`.

5\. Run `terraform init`.

6\. Run `terraform validate`.

7\. Review `terraform plan`.

8\. Run `terraform apply` after reviewing the costs.



\## Important



Terraform state, AWS credentials, datasets and generated ZIP packages are excluded from Git.

AWS resources may incur charges.

