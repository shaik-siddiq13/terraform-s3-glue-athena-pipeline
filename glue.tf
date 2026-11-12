
# Upload Glue ETL script to S3
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.processed.id
  key    = "scripts/transform.py"
  source = "glue-scripts/transform.py"

  etag = filemd5("glue-scripts/transform.py")
}

# AWS Glue ETL Job
resource "aws_glue_job" "retail_etl" {
  name     = "siddiq-online-retail-etl"
  role_arn = aws_iam_role.glue_role.arn

  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  timeout           = 10
  max_retries       = 0

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.processed.bucket}/${aws_s3_object.glue_script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--enable-metrics"                   = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--TempDir"                          = "s3://${aws_s3_bucket.processed.bucket}/temp/"
  }

  tags = {
    Project     = "Online Retail Data Pipeline"
    Environment = "Dev"
  }
}
