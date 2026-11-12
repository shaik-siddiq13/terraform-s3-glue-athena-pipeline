
# Glue Data Catalog Database
resource "aws_glue_catalog_database" "retail" {
  name = "siddiq_online_retail_db"
}

# Glue Crawler
resource "aws_glue_crawler" "retail" {
  name          = "siddiq-online-retail-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.retail.name

  s3_target {
    path = "s3://${aws_s3_bucket.processed.bucket}/cleaned/online-retail/"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  tags = {
    Project     = "Online Retail Data Pipeline"
    Environment = "Dev"
  }
}
