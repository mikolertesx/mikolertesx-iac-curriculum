variable "s3_bucket_name" {
  type        = string
  description = "S3 Bucket name for deployment"
}

variable "website_source_path" {
  type        = string
  description = "Absolute or relative path to the built static website files (e.g. NX React dist output)"
}
