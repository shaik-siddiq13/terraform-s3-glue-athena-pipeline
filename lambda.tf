
# Create AWS Lambda function
resource "aws_lambda_function" "trigger_glue" {
  function_name = "siddiq-retail-glue-trigger"

  role = aws_iam_role.lambda_role.arn

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  handler = "trigger_glue.lambda_handler"
  runtime = "python3.12"
  timeout = 60

  environment {
    variables = {
      GLUE_JOB_NAME = aws_glue_job.retail_etl.name
      OUTPUT_PATH   = "s3://${aws_s3_bucket.processed.bucket}/cleaned/online-retail/"
    }
  }

  tags = {
    Project     = "Online Retail Data Pipeline"
    Environment = "Dev"
  }
}

# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id   = "AllowExecutionFromS3"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.trigger_glue.function_name
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.raw.arn
  source_account = "776137448029"
}

# Configure S3 event notification
resource "aws_s3_bucket_notification" "raw_notification" {
  bucket = aws_s3_bucket.raw.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.trigger_glue.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "input/"
    filter_suffix       = ".csv"
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}
