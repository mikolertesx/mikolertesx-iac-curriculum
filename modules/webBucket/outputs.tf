output "s3_bucket_arn" {
  value = aws_s3_bucket.website_host_bucket.arn
  description = "ARN of S3 Bucket"
}

output "s3_bucket_id" {
  value = aws_s3_bucket.website_host_bucket.id
  description = "ID of S3 Bucket"
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.website_host_bucket.bucket_domain_name
  description = "Domain Name of S3 Bucket"
}
