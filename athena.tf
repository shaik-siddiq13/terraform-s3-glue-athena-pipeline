# Amazon Athena Workgroup
resource "aws_athena_workgroup" "retail" {
  name = "siddiq-online-retail-workgroup"

  configuration {
    enforce_workgroup_configuration = true

    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.processed.bucket}/athena-results/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }

    # Limit each query to 100 MB of scanned data
    bytes_scanned_cutoff_per_query = 100000000
  }

  tags = {
    Project     = "Online Retail Data Pipeline"
    Environment = "Dev"
  }
}