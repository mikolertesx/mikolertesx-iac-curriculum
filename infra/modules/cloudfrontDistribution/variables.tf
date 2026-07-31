variable "domain_name" {
  type        = string
  description = "Domain Name for cloud front distribution"
}

variable "s3_origin_id" {
  type        = string
  description = "S3 Bucket Origin ID for cloudFront target"
}

variable "s3_domain_name" {
  type        = string
  description = "S3 Bucket Domain Name"
}
