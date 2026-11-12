# Raw S3 bucket
resource "aws_s3_bucket" "raw" {
  bucket = var.raw_bucket_name

  tags = {
    Name        = "Raw Employee Data"
    Environment = "Dev"
    Project     = "S3 Glue Athena Pipeline"
  }
}

# Processed S3 bucket
resource "aws_s3_bucket" "processed" {
  bucket = var.processed_bucket_name

  tags = {
    Name        = "Cleaned Employee Data"
    Environment = "Dev"
    Project     = "S3 Glue Athena Pipeline"
  }
}

# Block public access to raw bucket
resource "aws_s3_bucket_public_access_block" "raw" {
  bucket = aws_s3_bucket.raw.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block public access to processed bucket
resource "aws_s3_bucket_public_access_block" "processed" {
  bucket = aws_s3_bucket.processed.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable encryption for raw bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "raw" {
  bucket = aws_s3_bucket.raw.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable encryption for processed bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "processed" {
  bucket = aws_s3_bucket.processed.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
