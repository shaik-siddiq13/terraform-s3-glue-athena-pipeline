
variable "raw_bucket_name" {
  description = "S3 bucket for raw employee CSV files"
  type        = string
  default     = "siddiq-raw-employees-776137448029"
}

variable "processed_bucket_name" {
  description = "S3 bucket for cleaned employee data"
  type        = string
  default     = "siddiq-cleaned-employees-776137448029"
}
