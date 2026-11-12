
# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "siddiq-retail-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

# Lambda CloudWatch logging permissions
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda permission to start the Glue job
resource "aws_iam_role_policy" "lambda_glue_access" {
  name = "lambda-start-glue-job"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect   = "Allow"
      Action   = ["glue:StartJobRun"]
      Resource = aws_glue_job.retail_etl.arn
    }]
  })
}

# Glue execution role
resource "aws_iam_role" "glue_role" {
  name = "siddiq-retail-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "glue.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

# Glue service permissions
resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Glue S3 read and write permissions
resource "aws_iam_role_policy" "glue_s3_access" {
  name = "glue-retail-s3-access"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      # List objects in raw and processed buckets
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.raw.arn,
          aws_s3_bucket.processed.arn
        ]
      },

      # Read raw CSV files, Glue script and cleaned Parquet files
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = [
          "${aws_s3_bucket.raw.arn}/*",
          "${aws_s3_bucket.processed.arn}/scripts/*",
          "${aws_s3_bucket.processed.arn}/cleaned/*"
        ]
      },

      # Write and delete processed Parquet files and temporary files
      {
        Effect = "Allow"

        Action = [
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.processed.arn}/*"
      }
    ]
  })
}
